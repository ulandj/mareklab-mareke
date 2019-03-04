from datetime import datetime
import json
import traceback
from django.core.exceptions import ObjectDoesNotExist
from django.http import HttpResponse
from django.shortcuts import render
from applause_app.forms import ApplauseForm
from django.db import transaction
from main_app.models import AuthUser, Applause, Timeline, Maareke, Post, Video, Photo, Comment
from main_app.utils import ACTION_TYPE, NoneToStr


def applause(request):
    if request.user.is_authenticated():
        if request.is_ajax():
            try:
                if request.POST:
                    form = ApplauseForm(request.POST)
                    if form.is_valid():
                        if request.user.id != int(form.data['from_user']):
                            return HttpResponse(
                                json.dumps({'status': False, 'message': 'Please, applause with your name!'}),
                                content_type="application/json")

                        if int(form.data['object_type']) in [0, 1]:
                            try:
                                with transaction.atomic():
                                    user = AuthUser.objects.get(pk=form.data['object_id'])
                                    user.applause_count += 1
                                    user.save()

                                    new_applause = Applause(object_id=form.data['object_id'],
                                                            object_type=form.data['object_type'],
                                                            from_user=form.data['from_user'],
                                                            to_user=form.data['object_id'])
                                    new_applause.save()

                                    new_timeline = Timeline(owner_id=form.data['object_id'],
                                                            action_type=ACTION_TYPE['applause'],
                                                            action_id=new_applause.id,
                                                            object_type=form.data['object_type'],
                                                            object_id=form.data['object_id'],
                                                            owner_name=NoneToStr(user.first_name) + ' ' + NoneToStr(
                                                                user.last_name), owner_avatar=user.avatar,
                                                            object_description=None, public=0,
                                                            friend_id=request.user.id,
                                                            friend_name = request.user.get_full_name(),
                                                            friend_avatar=request.user.avatar
                                    )
                                    new_timeline.save()
                            except ObjectDoesNotExist:
                                return HttpResponse(
                                    json.dumps({'status': False, 'message': 'User/Page does not exist!'}),
                                    content_type="application/json")

                        elif int(form.data['object_type']) == 2:
                            try:
                                with transaction.atomic():
                                    to_user = AuthUser.objects.get(pk=form.data['to_user'])

                                    maareke = Maareke.objects.get(pk=form.data['object_id'])
                                    maareke.applause_count += 1
                                    maareke.save()

                                    new_applause = Applause(object_id=form.data['object_id'],
                                                            object_type=form.data['object_type'],
                                                            from_user=form.data['from_user'], to_user=form.data['to_user'])
                                    new_applause.save()

                                    new_timeline = Timeline(owner_id=form.data['to_user'],
                                                            action_type=ACTION_TYPE['applause'],
                                                            action_id=new_applause.id,
                                                            object_type=form.data['object_type'],
                                                            object_id=form.data['object_id'],
                                                            owner_name=NoneToStr(to_user.first_name) + ' ' + NoneToStr(
                                                                to_user.last_name), owner_avatar=to_user.avatar,
                                                            object_description=None, public=0,
                                                            friend_id=request.user.id,
                                                            friend_name = request.user.get_full_name(),
                                                            friend_avatar=request.user.avatar
                                    )
                                    new_timeline.save()
                            except ObjectDoesNotExist:
                                return HttpResponse(json.dumps({'status': False, 'message': 'Maareke does not exist!'}),
                                                    content_type="application/json")

                        elif int(form.data['object_type']) == 3:
                            try:
                                with transaction.atomic():
                                    to_user = AuthUser.objects.get(pk=form.data['to_user'])

                                    post = Post.objects.get(pk=form.data['object_id'])
                                    post.applause_count += 1
                                    post.save()

                                    new_applause = Applause(object_id=form.data['object_id'],
                                                            object_type=form.data['object_type'],
                                                            from_user=form.data['from_user'], to_user=form.data['to_user'])
                                    new_applause.save()

                                    new_timeline = Timeline(owner_id=form.data['to_user'],
                                                            action_type=ACTION_TYPE['applause'],
                                                            action_id=new_applause.id,
                                                            object_type=form.data['object_type'],
                                                            object_id=form.data['object_id'],
                                                            owner_name=NoneToStr(to_user.first_name) + ' ' + NoneToStr(
                                                                to_user.last_name), owner_avatar=to_user.avatar,
                                                            object_description=None, public=0,
                                                            friend_id=request.user.id,
                                                            friend_name = request.user.get_full_name(),
                                                            friend_avatar=request.user.avatar
                                    )
                                    new_timeline.save()
                            except ObjectDoesNotExist:
                                return HttpResponse(json.dumps({'status': False, 'message': 'Post does not exist!'}),
                                                    content_type="application/json")

                        elif int(form.data['object_type']) == 4:
                            try:
                                with transaction.atomic():
                                    to_user = AuthUser.objects.get(pk=form.data['to_user'])

                                    video = Video.objects.get(pk=form.data['object_id'])
                                    video.applause_count += 1
                                    video.save()

                                    new_applause = Applause(object_id=form.data['object_id'],
                                                            object_type=form.data['object_type'],
                                                            from_user=form.data['from_user'], to_user=form.data['to_user'])
                                    new_applause.save()

                                    new_timeline = Timeline(owner_id=form.data['to_user'],
                                                            action_type=ACTION_TYPE['applause'],
                                                            action_id=new_applause.id,
                                                            object_type=form.data['object_type'],
                                                            object_id=form.data['object_id'],
                                                            owner_name=NoneToStr(to_user.first_name) + ' ' + NoneToStr(
                                                                to_user.last_name), owner_avatar=to_user.avatar,
                                                            object_description=None, public=0,
                                                            friend_id=request.user.id,
                                                            friend_name = request.user.get_full_name(),
                                                            friend_avatar=request.user.avatar
                                    )
                                    new_timeline.save()
                            except ObjectDoesNotExist:
                                return HttpResponse(json.dumps({'status': False, 'message': 'Video does not exist!'}),
                                                    content_type="application/json")

                        elif int(form.data['object_type']) == 5:
                            try:
                                with transaction.atomic():
                                    to_user = AuthUser.objects.get(pk=form.data['to_user'])

                                    photo = Photo.objects.get(pk=form.data['object_id'])
                                    photo.applause_count += 1
                                    photo.save()

                                    new_applause = Applause(object_id=form.data['object_id'],
                                                            object_type=form.data['object_type'],
                                                            from_user=form.data['from_user'], to_user=form.data['to_user'])
                                    new_applause.save()

                                    new_timeline = Timeline(owner_id=form.data['to_user'],
                                                            action_type=ACTION_TYPE['applause'],
                                                            action_id=new_applause.id,
                                                            object_type=form.data['object_type'],
                                                            object_id=form.data['object_id'],
                                                            owner_name=NoneToStr(to_user.first_name) + ' ' + NoneToStr(
                                                                to_user.last_name), owner_avatar=to_user.avatar,
                                                            object_description=None, public=0,
                                                            friend_id=request.user.id,
                                                            friend_name = request.user.get_full_name(),
                                                            friend_avatar=request.user.avatar
                                    )
                                    new_timeline.save()
                            except ObjectDoesNotExist:
                                return HttpResponse(json.dumps({'status': False, 'message': 'Photo does not exist!'}),
                                                    content_type="application/json")

                        elif int(form.data['object_type']) == 6:
                            try:
                                with transaction.atomic():
                                    to_user = AuthUser.objects.get(pk=form.data['to_user'])

                                    comment = Comment.objects.get(pk=form.data['object_id'])
                                    comment.applause_count += 1
                                    comment.save()

                                    new_applause = Applause(object_id=form.data['object_id'],
                                                            object_type=form.data['object_type'],
                                                            from_user=form.data['from_user'], to_user=form.data['to_user'])
                                    new_applause.save()

                                    new_timeline = Timeline(owner_id=form.data['to_user'],
                                                            action_type=ACTION_TYPE['applause'],
                                                            action_id=new_applause.id,
                                                            object_type=form.data['object_type'],
                                                            object_id=form.data['object_id'],
                                                            owner_name=NoneToStr(to_user.first_name) + ' ' + NoneToStr(
                                                                to_user.last_name), owner_avatar=to_user.avatar,
                                                            object_description=None, public=0,
                                                            friend_id=request.user.id,
                                                            friend_name = request.user.get_full_name(),
                                                            friend_avatar=request.user.avatar
                                    )
                                    new_timeline.save()
                            except ObjectDoesNotExist:
                                return HttpResponse(json.dumps({'status': False, 'message': 'Comment does not exist!'}),
                                                    content_type="application/json")

                        else:
                            return HttpResponse(json.dumps({'status': False, 'message': 'Invalid maareke object!'}),
                                                content_type="application/json")

                        return HttpResponse(json.dumps({'status': True}), content_type="application/json")
                    else:
                        return HttpResponse(json.dumps({'status': False, 'message': form.errors['__all__'][0]}),
                                            content_type="application/json")
                else:
                    return HttpResponse(json.dumps({'status': False, 'message': 'Request must be a POST!'}),
                                        content_type="application/json")
            except:
                print(traceback.format_exc())
                return HttpResponse(json.dumps({'status': False, 'message': 'Server ERROR!'}),
                                    content_type="application/json")

        else:
            return HttpResponse(json.dumps({'status': False, 'message': 'Request must be a AJAX!'}),
                                content_type="application/json")
    else:
        return HttpResponse(json.dumps({'data': 'You are not authenticated!'}),
                            content_type="application/json")


def get_object_applause_count(object_type, object_id):
    try:
        if int(object_type) == 2:
            maareke = Maareke.objects.get(pk=object_id)
            return maareke.applause_count
        elif int(object_type) == 3:
            post = Post.objects.get(pk=object_id)
            return post.applause_count
        elif int(object_type) == 4:
            video = Video.objects.get(pk=object_id)
            return video.applause_count
        elif int(object_type) == 5:
            photo = Photo.objects.get(pk=object_id)
            return photo.applause_count
        elif int(object_type) == 6:
            comment = Comment.objects.get(pk=object_id)
            return comment.applause_count
    except:
        return 0