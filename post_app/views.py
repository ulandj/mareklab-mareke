# -*- coding: utf-8 -*-
from datetime import datetime
import json
import os
import traceback
import time

from PIL import Image
from boto.s3.connection import S3Connection
from boto.s3.key import Key
from django.db import transaction
from django.db.models import Q
from django.http import HttpResponse
from django.shortcuts import render, redirect

from main_app.models import Post, Timeline, Photo, Albums, Video
from main_app.utils import ACTION_TYPE, MAAREKE_OBJECT
from post_app.forms import ShareTextForm, SharePhotoForm, ShareVideoForm


def share_text_post(request):
    if request.user.is_authenticated():
        form = ShareTextForm(request.POST)
        if form.is_valid():
            try:
                with transaction.atomic():
                    new_post = Post(owner_id=request.user.id, description=form.data['share_text'],
                                    public=form.data['share_public']
                    )
                    new_post.save()

                    new_timeline = Timeline(owner_id=request.user.id, action_type=ACTION_TYPE['post'],
                                            object_type=MAAREKE_OBJECT['post'], object_id=new_post.id,
                                            owner_name=request.user.get_full_name(), owner_avatar=request.user.avatar,
                                            object_description=form.data['share_text'], public=form.data['share_public']
                    )
                    new_timeline.save()

                    return HttpResponse(json.dumps({'success': True}),
                                        content_type="application/json")
            except:
                return HttpResponse(json.dumps({'success': False, 'message': 'Error when saving post!'}),
                                    content_type="application/json")
        else:
            return HttpResponse(json.dumps({'success': False, 'message': form.errors['__all__'][0]}),
                                content_type="application/json")
    else:
        return HttpResponse(json.dumps({'success': False, 'message': 'You are not authenticated!'}),
                            content_type="application/json")


def share_photo_post(request):
    if request.user.is_authenticated():
        form = SharePhotoForm(request.POST, request.FILES)
        if form.is_valid():
            try:
                album = Albums.objects.get(Q(album_type=0), Q(owner_id=request.user.id))
            except:
                album = Albums(owner_id=request.user.id, album_type=0)
                album.save()

            uploaded_file = request.FILES.get('filePhoto')

            image = Image.open(uploaded_file)
            (width, height) = image.size

            if width < 200 and height < 200:
                return HttpResponse(json.dumps({'success': False, 'message': 'Image is too small, must be bigger than 500x500!'}),
                                    content_type="application/json")

            try:
                with transaction.atomic():
                    photo = Photo(owner_id=request.user.id, album_id=album.id, description=form.data['share_photo_desc'])
                    photo.save()

                    file_name = 'share_photo_' + str(photo.id) + '.png'

                    photo.title = file_name
                    photo.save()

                    new_timeline = Timeline(owner_id=request.user.id, action_type=ACTION_TYPE['photo'],
                                            object_type=MAAREKE_OBJECT['photo'], object_id=photo.id,
                                            owner_name=request.user.get_full_name(), owner_avatar=request.user.avatar,
                                            object_description=form.data['share_photo_desc'], public=form.data['share_public'],
                                            object_file_url=file_name
                    )
                    new_timeline.save()

                    basewidth = 800
                    basewidth2 = 500
                    if width > basewidth:
                        wpercent = (basewidth / float(image.size[0]))
                        hsize = int((float(image.size[1]) * float(wpercent)))

                        size = basewidth, hsize
                        image_800 = image.resize(size, Image.ANTIALIAS)
                        image_800.save('static/images/800/' + file_name, format='PNG')

                        conn = S3Connection('AKIAILFBQV7J6PWVHZLQ', 'Fntds+9R/rThjJ68XKCBporsfYY3AzyW0DX6vEls')
                        bucket = conn.get_bucket('maareke-image', validate=False)
                        k = Key(bucket)

                        # Image upload to S3
                        k.key = '800/' + file_name  # for example, 'images/bob/resized_image1.png'
                        fn_image = 'static/images/800/' + file_name

                        try:
                            k.set_contents_from_filename(fn_image)
                        except:
                            pass
                        finally:
                            k.make_public()

                    if width > basewidth2:
                        wpercent = (basewidth2 / float(image.size[0]))
                        hsize = int((float(image.size[1]) * float(wpercent)))

                        size = basewidth2, hsize
                        image_500 = image.resize(size, Image.ANTIALIAS)
                        image_500.save('static/images/500/' + file_name, format='PNG')

                        conn = S3Connection('AKIAILFBQV7J6PWVHZLQ', 'Fntds+9R/rThjJ68XKCBporsfYY3AzyW0DX6vEls')
                        bucket = conn.get_bucket('maareke-image', validate=False)
                        k = Key(bucket)

                        # Image upload to S3
                        k.key = '500/' + file_name  # for example, 'images/bob/resized_image1.png'
                        fn_image = 'static/images/500/' + file_name

                        try:
                            k.set_contents_from_filename(fn_image)
                        except:
                            pass
                        finally:
                            k.make_public()
                    else:
                        image.save('static/images/500/' + file_name, format='PNG')

                        conn = S3Connection('AKIAILFBQV7J6PWVHZLQ', 'Fntds+9R/rThjJ68XKCBporsfYY3AzyW0DX6vEls')
                        bucket = conn.get_bucket('maareke-image', validate=False)
                        k = Key(bucket)

                        # Image upload to S3
                        k.key = '500/' + file_name  # for example, 'images/bob/resized_image1.png'
                        fn_image = 'static/images/500/' + file_name

                        try:
                            k.set_contents_from_filename(fn_image)
                        except:
                            pass
                        finally:
                            k.make_public()
            except:
                print(traceback.format_exc())
                return HttpResponse(
                    json.dumps({'success': False, 'message': 'Возникла ошибка при загрузке изображения!'}),
                    content_type="application/json")
            finally:
                try:
                    os.remove('static/images/500/' + file_name)
                    os.remove('static/images/800/' + file_name)
                except:
                    pass

            return HttpResponse(json.dumps({'success': True}), content_type="application/json")
        else:
            return HttpResponse(
                json.dumps({'success': False, 'message': form.errors['__all__'][0]}),
                content_type="application/json")
    else:
        return HttpResponse(json.dumps({'success': False, 'message': 'You are not authenticated!'}),
                            content_type="application/json")


def share_video_post(request):
    if request.user.is_authenticated():
        if request.is_ajax():
            if request.POST:
                form = ShareVideoForm(request.POST, request.FILES)
                if form.is_valid():
                    try:
                        with transaction.atomic():
                            uploaded_file = request.FILES['video_file']
                            fileName, fileExtension = os.path.splitext(uploaded_file.name)
                            fileName = 'share_video_' + str(time.time())
                            uploaded_file.name = fileName + fileExtension

                            video = Video(original_file=request.FILES['video_file'], description=form.data['share_video_desc'],
                                             owner_id=request.user.id, converted_file=fileName + '.mp4')
                            video.save()

                            new_timeline = Timeline(owner_id=request.user.id, action_type=ACTION_TYPE['video'],
                                                    object_type=MAAREKE_OBJECT['video'], object_id=video.id,
                                                    owner_name=request.user.get_full_name(), owner_avatar=request.user.avatar,
                                                    object_description=form.data['share_video_desc'], public=form.data['share_public'],
                                                    object_file_url=fileName, is_ready_to_show=False
                            )
                            new_timeline.save()

                            return HttpResponse(json.dumps({'success': True}), content_type="application/json")
                    except:
                        return HttpResponse(json.dumps({'success': False, 'message': 'Error when saving file to server!'}),
                                            content_type="application/json")
                else:
                    print(form.errors)
                    return HttpResponse(
                        json.dumps({'success': False, 'message': 'Заполните все поля правильными данными!'}),
                        content_type="application/json")

            return HttpResponse(json.dumps({'success': False, 'message': 'Request must be POST!'}),
                                content_type="application/json")
        else:
            return redirect('home')
    else:
        return HttpResponse(json.dumps({'success': False, 'message': 'You are not authenticated!'}),
                            content_type="application/json")



def share_event(request):
    pass
