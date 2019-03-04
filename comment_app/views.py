import json

from django.contrib.auth.decorators import login_required
from django.db.models import Q
from django.http import HttpResponse
from django.db import transaction

from comment_app.forms import CommentGetForm, CommentAddForm, CommentDeleteForm
from main_app.helper import maareke_object_item_exist, get_maareke_object_owner
from main_app.models import Comment, Timeline, AuthUser
from main_app.utils import NoneToStr, ACTION_TYPE


@login_required
def get_comments(request):
    if request.POST:
        form = CommentGetForm(request.POST)
        if form.is_valid():
            try:
                comments = Comment.objects.filter(Q(object_type=form.data['object_type']),
                                                  Q(object_id=form.data['object_id']))

                comment_list = []
                for comment in comments:
                    comment_object = {}
                    comment_object['text'] = comment.text
                    comment_object['comment_id'] = comment.id

                    comment_list.append(comment_object)

                response = {'success': True, 'comments': comment_list}
                return HttpResponse(json.dumps(response), content_type="application/json")
            except:
                return HttpResponse(json.dumps({'success': False, 'message': 'Server error!'}),
                                    content_type="application/json")
        else:
            response = {'success': False, 'message': 'Invalid data for comment!'}
            return HttpResponse(json.dumps(response), content_type="application/json")
    else:
        response = {'success': False, 'message': 'Request must be a POST!'}
        return HttpResponse(json.dumps(response), content_type="application/json")


def add_comment(request):
    if request.user.is_authenticated():
        if request.is_ajax():
            if request.POST:
                form = CommentAddForm(request.POST)
                if form.is_valid():
                    if maareke_object_item_exist(form.data['object_type'], form.data['object_id']):
                        try:
                            try:
                                timeline = Timeline.objects.get(Q(friend_id=request.user.id),
                                                                Q(object_type=form.data['object_type']),
                                                                Q(object_id=form.data['object_id']),
                                                                Q(action_type=ACTION_TYPE['comment']))
                                exist = True
                            except:
                                exist = False

                            with transaction.atomic():
                                new_comment = Comment(owner_id=request.user.id, text=form.data['text'],
                                                      object_type=form.data['object_type'],
                                                      object_id=form.data['object_id'])
                                new_comment.save()

                                if not exist:
                                    to_user = AuthUser.objects.get(
                                        pk=get_maareke_object_owner(form.data['object_type'], form.data['object_id']))

                                    new_timeline = Timeline(owner_id=to_user.id,
                                                            action_type=ACTION_TYPE['comment'],
                                                            action_id=new_comment.id,
                                                            object_type=form.data['object_type'],
                                                            object_id=form.data['object_id'],
                                                            owner_name=NoneToStr(to_user.first_name) + ' ' + NoneToStr(
                                                                to_user.last_name), owner_avatar=to_user.avatar,
                                                            object_description=None, public=0,
                                                            friend_id=request.user.id,
                                                            friend_name=request.user.get_full_name(),
                                                            friend_avatar=request.user.avatar
                                    )
                                    new_timeline.save()

                                response = {
                                    'success': True,
                                    'comment_id': new_comment.id,
                                    'datetime': str(new_comment.datetime),
                                    'applause': 0,
                                    'show_delete': True,
                                    'author': request.user.get_full_name(),
                                    'author_id': request.user.id,
                                    'author_avatar': NoneToStr(request.user.avatar)
                                }
                                return HttpResponse(json.dumps(response), content_type="application/json")
                        except:
                            return HttpResponse(json.dumps({'status': False, 'message': 'Server error!'}),
                                                content_type="application/json")
                    else:
                        return HttpResponse(json.dumps({'status': False, 'message': 'Maareke object does not exist!'}),
                                            content_type="application/json")
                else:
                    response = {'success': False, 'message': 'Invalid data for comment!'}
                    return HttpResponse(json.dumps(response), content_type="application/json")

            else:
                response = {'success': False, 'message': 'Request must be a POST!'}
                return HttpResponse(json.dumps(response), content_type="application/json")
        else:
            return HttpResponse(json.dumps({'status': False, 'message': 'Its not ajax request!'}),
                                content_type="application/json")
    else:
        return HttpResponse(json.dumps({'data': 'You are not authenticated!'}),
                            content_type="application/json")


def delete_comment(request):
    if request.user.is_authenticated():
        if request.is_ajax():
            if request.POST:
                form = CommentDeleteForm(request.POST)
                if form.is_valid():
                    if maareke_object_item_exist(form.data['object_type'], form.data['object_id']):
                        try:
                            with transaction.atomic():
                                Comment.objects.filter(id=form.data['comment_id']).delete()

                                Timeline.objects.filter(object_type=form.data['object_type'],
                                                        object_id=form.data['object_id'],
                                                        action_type=ACTION_TYPE['comment'],
                                                        action_id=form.data['comment_id']).delete()

                                response = {'success': True}
                                return HttpResponse(json.dumps(response), content_type="application/json")
                        except:
                            return HttpResponse(json.dumps({'success': False, 'message': 'Server error!'}),
                                                content_type="application/json")
                    else:
                        return HttpResponse(json.dumps({'success': False, 'message': 'Maareke object does not exist!'}),
                                            content_type="application/json")
                else:
                    response = {'success': False, 'message': 'Invalid data for delete comment!'}
                    return HttpResponse(json.dumps(response), content_type="application/json")
            else:
                response = {'success': False, 'message': 'Request must be a POST!'}
                return HttpResponse(json.dumps(response), content_type="application/json")
        else:
            return HttpResponse(json.dumps({'success': False, 'message': 'Its not ajax request!'}),
                                content_type="application/json")
    else:
        return HttpResponse(json.dumps({'success': False, 'message': 'You are not authenticated!'}),
                            content_type="application/json")