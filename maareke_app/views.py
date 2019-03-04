import json
import traceback
import datetime

from django.contrib.auth.decorators import login_required
from django.db import transaction
from django.http import HttpResponse
from django.shortcuts import render
from django.views.generic import TemplateView

from maareke_app.forms import CreatePageForm, CreateEventForm
from main_app.models import PageType, PageTypeProperty, AuthUser, PageProperty, Maareke, Timeline
from main_app.utils import ACTION_TYPE, MAAREKE_OBJECT, datetime_from_str


@login_required
def create_maareke(request):
    page_types = PageType.objects.all()
    return render(request, 'maareke/create_page.html', {'page_types': page_types})


class GetPageFieldsView(TemplateView):
    def get_context_data(self, **kwargs):

        context = super(GetPageFieldsView, self).get_context_data(**kwargs)

        try:
            if 'HTTP_X_REQUESTED_WITH' in self.request.environ and int(self.request.GET['page_type']):
                self.template_name = "maareke/fields.html"
            else:
                self.template_name = "maareke/http_404.html"
        except:
            self.template_name = "maareke/http_404.html"

        try:
            page_type_id = int(self.request.GET['page_type'])

            fields = PageTypeProperty.objects.raw("""
                    SELECT p.title page_type_title,
                            d.name data_type_title,
                            pp.title, pp.default_value, pp.id
                    FROM page_type_property pp, page_type p, data_type d
                    where pp.page_type_id = p.id
                    and pp.data_type_id = d.id
                    and pp.page_type_id = {0}
            """.format(page_type_id))
        except:
            fields = None

        # update the context
        context.update(fields=fields)
        return context


def create_page(request):
    if request.user.is_authenticated():
        if request.is_ajax():
            if request.POST:
                form = CreatePageForm(request.POST)
                if form.is_valid():
                    page_type_properties = PageTypeProperty.objects.filter(page_type_id=form.data['page_type'])

                    # TODO check country, region


                    for field in page_type_properties:
                        if field.required:
                            post_field = request.POST.get(field.title, None)
                            if post_field is None:
                                return HttpResponse(
                                    json.dumps({'success': False, 'message': str(field.title) + ' field is required!'}),
                                    content_type="application/json")

                    try:
                        with transaction.atomic():
                            new_page = AuthUser(page_type=form.data['page_type'], first_name=form.data['title'],
                                                country=form.data['country'], region=form.data['region'],
                                                address=form.data['address'], description=form.data['description'],
                                                phone=request.POST['phone_number'], parent_id=request.user.id,
                                                is_superuser=False,
                                                is_staff=True, is_active=True
                            )

                            new_page.save()

                            for field in page_type_properties:
                                post_field = request.POST.get(field.title, None)
                                new_page_property = PageProperty(page_id=new_page.id, page_type_property_id=field.id,
                                                                 value=post_field)
                                new_page_property.save()

                        return HttpResponse(
                            json.dumps({'success': True, 'data': {'id': new_page.id, 'title': new_page.first_name}}),
                            content_type="application/json")
                    except:
                        return HttpResponse(json.dumps({'success': False, 'message': 'Error when creating a page!'}),
                                            content_type="application/json")
                else:
                    return HttpResponse(json.dumps({'success': False, 'message': form.errors}),
                                        content_type="application/json")
            else:
                response = {'success': False, 'message': 'Request must be a POST!'}
                return HttpResponse(json.dumps(response), content_type="application/json")
        else:
            return HttpResponse(json.dumps({'success': False, 'message': 'Its not ajax request!'}),
                                content_type="application/json")
    else:
        return HttpResponse(json.dumps({'success': False, 'message': 'You are not authenticated!'}),
                            content_type="application/json")


@login_required
def get_page_list(request):
    pages = AuthUser.objects.filter(parent_id__isnull=False)

    return render(request, 'maareke/maarekers.html', {'pages': pages})


def create_event(request):
    if request.user.is_authenticated():
        if request.is_ajax():
            if request.POST:
                form = CreateEventForm(request.POST)
                if form.is_valid():
                    try:
                        with transaction.atomic():
                            new_maareke = Maareke(owner_id=request.user.id, title=form.data['title'],
                                                  description=form.data['description'], location=form.data['location'],
                                                  country=request.user.country, region=request.user.region,
                                                  event_date=datetime.datetime.strptime(form.data['date'], '%Y-%m-%d'),
                                                  event_time=form.data['time']
                            )
                            new_maareke.save()

                            new_timeline = Timeline(owner_id=request.user.id, action_type=ACTION_TYPE['event'],
                                                    object_type=MAAREKE_OBJECT['event'], object_id=new_maareke.id,
                                                    owner_name=request.user.get_full_name(),
                                                    owner_avatar=request.user.avatar,
                                                    object_description=form.data['description'],
                                                    public=form.data['share_public']
                            )
                            new_timeline.save()

                            return HttpResponse(json.dumps({'success': True, 'message': 'Event successfully created!'}),
                                                content_type="application/json")
                    except:
                        print(traceback.format_exc())
                        return HttpResponse(json.dumps({'success': False, 'message': 'Error when creating event!'}),
                                            content_type="application/json")
                else:
                    return HttpResponse(json.dumps({'success': False, 'message': form.errors}),
                                        content_type="application/json")
            else:
                response = {'success': False, 'message': 'Request must be a POST!'}
                return HttpResponse(json.dumps(response), content_type="application/json")
        else:
            return HttpResponse(json.dumps({'success': False, 'message': 'Its not ajax request!'}),
                                content_type="application/json")
    else:
        return HttpResponse(json.dumps({'success': False, 'message': 'You are not authenticated!'}),
                            content_type="application/json")