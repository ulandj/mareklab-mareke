import json
import traceback

from django.db.models import Q
from django.http import HttpResponse, Http404
from django.shortcuts import render

from applause_app.views import get_object_applause_count
from main_app.models import Comment, Timeline, AuthUser, Friends, Region, PageTypeProperty
from main_app.utils import NoneToStr



def home_page(request):
    if request.user.is_authenticated():
        # TODO fill user country, region
        if request.user.country is None or request.user.region is None:
            pass
        return render(request, 'index.html')
    else:
        return render(request, 'login.html')


def main_page_posts(request):
    if request.user.is_authenticated():
        try:
            response = []
            start = int(request.GET['start'])
            limit_count = 1
            end = start + limit_count

            user_param = None
            try:
                if request.GET.get('user', None):
                    user_param = int(request.GET['user'])
            except:
                user_param = None

            if user_param:
                friends = []
                if request.user.id == user_param:
                    timelines = Timeline.objects.filter(Q(owner_id=user_param), Q(is_ready_to_show=True),
                                                        Q(friend_id__isnull=True)).order_by('-datetime')[start:end]
                else:
                    timelines = Timeline.objects.filter(Q(owner_id=user_param), Q(is_ready_to_show=True), Q(public=0),
                                                        Q(friend_id__isnull=True)).order_by('-datetime')[start:end]
            else:
                friends = list(Friends.objects.values_list('friend_id', flat=True).filter(Q(owner_id=request.user.id),
                                                                                          Q(request=1)))
                friends.append(request.user.id)

                timelines = Timeline.objects.filter(
                    (Q(owner_id__in=friends) | Q(friend_id__in=friends)) & Q(is_ready_to_show=True)).order_by(
                    '-datetime')[start:end]

            for timeline in timelines:
                timeline_obj = {}
                timeline_obj['id'] = timeline.id
                timeline_obj['url'] = NoneToStr(timeline.object_file_url)
                timeline_obj['datetime'] = str(timeline.datetime)
                timeline_obj['desc'] = timeline.object_description
                timeline_obj['applause'] = get_object_applause_count(timeline.object_type, timeline.object_id)
                timeline_obj['share'] = 0
                timeline_obj['author'] = timeline.owner_name
                timeline_obj['author_id'] = timeline.owner_id
                timeline_obj['author_avatar'] = timeline.owner_avatar
                timeline_obj['object_type'] = timeline.object_type
                timeline_obj['object_id'] = timeline.object_id
                timeline_obj['action_title'] = ''
                timeline_obj['friend_id'] = ''
                timeline_obj['friend_name'] = ''
                timeline_obj['friend_avatar'] = ''

                if timeline.friend_id is not None:
                    if timeline.friend_id in friends and timeline.action_type == 4:
                        timeline_obj['action_title'] = 'commented with'
                        timeline_obj['friend_id'] = NoneToStr(timeline.friend_id)
                        timeline_obj['friend_name'] = NoneToStr(timeline.friend_name)
                        timeline_obj['friend_avatar'] = NoneToStr(timeline.friend_avatar)
                    elif timeline.friend_id in friends and timeline.action_type == 5:
                        timeline_obj['action_title'] = 'applauded with'
                        timeline_obj['friend_id'] = NoneToStr(timeline.friend_id)
                        timeline_obj['friend_name'] = NoneToStr(timeline.friend_name)
                        timeline_obj['friend_avatar'] = NoneToStr(timeline.friend_avatar)

                comments = Comment.objects.raw(
                    """
                    select c.*,
                           u.first_name,
                           u.last_name,
                           u.avatar
                    from comment c, auth_user u
                    where c.object_type = {0}
                    and c.object_id = {1}
                    and u.id = c.owner_id
                    order by c.id
                    """.format(timeline.object_type, timeline.object_id)
                )

                comment_list = []
                for comment in comments:
                    comment_object = {}
                    comment_object['text'] = comment.text
                    comment_object['comment_id'] = comment.id
                    comment_object['datetime'] = str(comment.datetime)
                    comment_object['applause'] = comment.applause_count
                    comment_object['show_delete'] = True if request.user.id in [timeline.owner_id,
                                                                                comment.owner_id] else False
                    comment_object['author'] = comment.first_name + ' ' + NoneToStr(comment.last_name)
                    comment_object['author_id'] = comment.owner_id
                    comment_object['author_avatar'] = NoneToStr(comment.avatar)

                    comment_list.append(comment_object)

                timeline_obj['comments'] = comment_list

                response.append(timeline_obj)

            if len(response) == 0:
                end = start
            else:
                end = start + limit_count

            return HttpResponse(json.dumps({'data': response, 'last_id': end}),
                                content_type="application/json")
        except:
            print(traceback.format_exc())
            return HttpResponse(json.dumps({'data': [], 'last_id': request.GET['start']}),
                                content_type="application/json")
    else:
        return HttpResponse(json.dumps({'data': 'You are not authenticated!'}),
                            content_type="application/json")


def search_data(request, text=None):
    if request.user.is_authenticated():
        if request.is_ajax():
            response = []
            if text is not None:
                users = AuthUser.objects.filter(Q(first_name__icontains=text) | Q(last_name__icontains=text))[:20]

                for user in users:
                    user_obj = {}
                    user_obj['id'] = user.id
                    user_obj['full_name'] = NoneToStr(user.first_name) + ' ' + NoneToStr(user.last_name)
                    user_obj['info'] = ''

                    if user.country:
                        country = Region.objects.get(pk=user.country)
                        user_obj['info'] = country.title

                    if user.region:
                        region = Region.objects.get(pk=user.region)
                        user_obj['info'] += ', ' + region.title

                    response.append(user_obj)

            return HttpResponse(json.dumps(response), content_type="application/json")
        else:
            return HttpResponse(json.dumps({'status': False, 'message': 'Its not ajax request!'}),
                                content_type="application/json")
    else:
        return HttpResponse(json.dumps({'data': 'You are not authenticated!'}),
                            content_type="application/json")
