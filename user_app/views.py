# coding: utf-8
import datetime
import json
import traceback

from django.contrib.auth.decorators import login_required
from django.contrib.auth.hashers import make_password
from django.core.exceptions import ObjectDoesNotExist
from django.db.models import Q
from django.http import HttpResponseRedirect, HttpResponse, Http404
from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, logout
from django.contrib import auth
from django.db import connection, transaction
from authomatic.adapters import DjangoAdapter
from maareke import settings

from maareke.settings import FB_AUTHOMATIC
from main_app.models import AuthUser, Region, Friends
from main_app.utils import datetime_from_str, send_email, getNewEmailCode, NoneToStr
from user_app.forms import RegistrationForm


def login(request):
    if request.POST:
        email = request.POST['email']
        password = request.POST['password']
        user = authenticate(email=email, password=password)
        if user is not None:
            if user.is_active:
                auth.login(request, user)
                return redirect('home')
            else:
                return render(request, 'login.html', {'login_error': 'You are not activated yet!'})
        else:
            return render(request, 'login.html', {'login_error': 'Login or Password incorrect!'})

    return redirect('home')


def fb_login(request):
    # We we need the response object for the adapter.
    response = HttpResponse()

    # Start the login procedure.
    result = FB_AUTHOMATIC.login(DjangoAdapter(request, response), 'fb')

    # If there is no result, the login procedure is still pending.
    # Don't write anything to the response if there is no result!
    if result:
        if result.error:
            # Login procedure finished with an error.
            return render(request, 'login.html',
                          {'login_error': '<h2>Damn that error: {0}</h2>'.format(result.error.message)})

        elif result.user:
            # Hooray, we have the user!

            # OAuth 2.0 and OAuth 1.0a provide only limited user data on login,
            # We need to update the user to get more info.
            if not (result.user.name and result.user.id):
                result.user.update()

            try:
                fb_user = AuthUser.objects.get(email=result.user.email)
                if fb_user.fb_id is None:
                    fb_user.fb_id = result.user.id
                    fb_user.save()
            except:
                try:
                    fb_user = AuthUser.objects.get(fb_id=result.user.id)
                except ObjectDoesNotExist:
                    gender = None
                    if result.user.gender:
                        gender = 1 if result.user.gender == 'male' else 0

                    birthday = datetime_from_str(result.user.data['birthday'])[1] if result.user.data[
                        'birthday'] else None

                    fb_user = AuthUser(username=result.user.email,
                                       password=make_password('maareke' + str(datetime.datetime.now())),
                                       first_name=result.user.first_name, last_name=result.user.last_name,
                                       email=result.user.email, activation_code=None, is_active=True,
                                       fb_id=result.user.id, gender=gender, birthday=birthday)
                    fb_user.save()

            request.session[fb_user.email] = result.user.credentials.token

            user = authenticate(fb_id=result.user.id)
            if user is not None:
                auth.login(request, user)

            return redirect('home')

    return response


def register(request):
    if request.user.is_authenticated():
        return redirect('home')

    if request.POST:
        form = RegistrationForm(request.POST)

        if form.is_valid():
            try:
                birthday = datetime.date(int(form.data['birth_year']), int(form.data['birth_month']),
                                         int(form.data['birth_day']))

                p_email_code = getNewEmailCode(form.data['email'])

                new_user = AuthUser(password=make_password(form.data['password']), username=form.data['email'],
                                    first_name=form.data['first_name'], last_name=form.data['last_name'],
                                    email=form.data['email'], activation_code=p_email_code, birthday=birthday,
                                    gender=form.data['gender'])
                new_user.save()

                content_style = 'font-size: 12px; width: 500px; text-align: justify;'
                site_url = 'https://www.maareke.com'
                subject = 'Активация на WWW.MAAREKE.COM'

                message = """
                        <h1 style='font-size: 18px;'>Здравствуйте!</h1>
                        <p style='{0}'>
                        Вы получили это письмо, потому что Ваш адрес электронной почты был указан при регистрации на сайте MaarekeLAB (www.maareke.com).
                        Если Вы не регистрировались на указанном сайте, просто проигнорируйте и удалите это письмо. <br/>
                        Чтобы подтвердить регистрацию, перейдите по этой ссылке:<br/><a href='http://54.186.10.240/activation/?code={2}'>пройдите по этой ссылки.</a>
                        </p>
                        <p style='{0}'>Вы должны подтвердить Вашу регистрацию в течение 72 часов.
                        Для входа в систему используйте логин и пароль,что Вы указали при регистрации.
                        Если ссылка не открывается, скопируйте её и вставьте в адресную строку браузера.
                        Подтверждение регистрации включает в себя полное принятие Пользовательского соглашения.</p>
                        <p style='{0}'>Спасибо за Ваш выбор!</p>
                        <p style='{0}'>С уважением, MaarekeLAB.<br>
                        <a href='{1}' target='_blank'>www.maareke.com</a><br/><br/>
                        Телефон для справок:&nbsp;+996-312-97-67-39</p>
                          """.format(content_style, site_url, p_email_code)

                from_email = 'maareke@gmail.com'
                if subject and message and from_email:
                    if not send_email([form.data['email']], subject, message):
                        return render(request, 'register.html',
                                      {'register_error': 'Invalid header found when email sending!'})

                    return render(request, 'register.html', {'register_success': 'Activation code sent in your email!'})
                else:
                    # In reality we'd use a form class
                    # to get proper validation errors.
                    return render(request, 'register.html',
                                  {'register_error': 'Make sure all fields are entered and valid.'})
            except:
                print(traceback.format_exc())
                return render(request, 'register.html', {'register_error': 'Error when registering!'})
        else:
            return render(request, 'register.html', {'form': form})

    return render(request, 'register.html')


def register_activation(request):
    if request.GET.get('code'):
        try:
            user = AuthUser.objects.get(activation_code=request.GET['code'])
            user.activation_code = None
            user.is_active = True
            user.save()

            return render(request, 'login.html', {'login_success': 'You successfully activated!'})
        except ObjectDoesNotExist:
            return render(request, 'login.html', {'login_error': 'Activation Code not exist!'})

    return redirect('home')


def user_logout(request):
    fb_token = request.session.get(request.user.username)
    logout(request)

    if fb_token:
        return HttpResponseRedirect(
            'https://www.facebook.com/logout.php?next=' + settings.FB_LOGOUT_REDIRECT + '&access_token=' + fb_token)
    else:
        return redirect('home')


@login_required
def another_user_home(request, user_id=None):
    try:
        user = AuthUser.objects.get(pk=user_id)

        country = Region.objects.filter(pk=user.country)
        region = Region.objects.filter(pk=user.region)

        try:
            friends = Friends.objects.get(Q(owner_id=request.user.id), Q(friend_id=user_id))
        except ObjectDoesNotExist:
            friends = None

        owner = {}
        if country:
            owner['country'] = NoneToStr(country[0].title)
            owner['region'] = NoneToStr(region[0].title)
        else:
            owner['country'] = ''
            owner['region'] = ''

        if friends:
            owner['friend_request'] = friends.request
        else:
            owner['friend_request'] = ''

        return render(request, 'user_index.html', {'page_owner': user, 'owner': owner})
    except:
        print(traceback.format_exc())
        raise Http404


def add_friend(request):
    if request.user.is_authenticated():
        if request.is_ajax():
            if request.POST:
                try:
                    user = AuthUser.objects.get(pk=request.POST['user'])
                except:
                    return HttpResponse(json.dumps({'success': False, 'message': 'User not exist!'}),
                                        content_type="application/json")

                try:
                    friend = Friends.objects.get(Q(owner_id=request.user.id), Q(friend_id=request.POST['user']))

                    if friend.request == 0:
                        return HttpResponse(json.dumps({'success': True}), content_type="application/json")
                    elif friend.request == 1:
                        return HttpResponse(json.dumps({'success': False, 'message': 'You are already friend!'}),
                                            content_type="application/json")
                    elif friend.request == 2:
                        return HttpResponse(
                            json.dumps({'success': False, 'message': 'Did not accept your friend request!'}),
                            content_type="application/json")
                except:
                    pass

                friend = Friends(owner_id=request.user.id, friend_id=request.POST['user'], request=0)
                friend.save()

                return HttpResponse(json.dumps({'success': True}), content_type="application/json")
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
def friend_request_page(request):
    friend_request = Friends.objects.filter(Q(friend_id=request.user.id), Q(request=0))

    response = []
    for friend in friend_request:
        result = {}
        user = AuthUser.objects.get(pk=friend.owner_id)
        result['id'] = user.id
        result['name'] = NoneToStr(user.first_name) + ' ' + NoneToStr(user.last_name)
        result['avatar'] = NoneToStr(user.avatar)
        result['type'] = 'friend_requests'

        cursor = connection.cursor()
        cursor.execute("""
            SELECT count(DISTINCT a.friend_id) as v_count FROM friends a
            join friends b
            on a.friend_id = b.friend_id
            and a.owner_id = {0}
            and b.owner_id = {1}
        """.format(request.user.id, user.id))
        mutual = cursor.fetchone()

        result['mutual_friend_count'] = mutual[0]

        response.append(result)

    return render(request, 'user/friend.html', {'friends': response})


@login_required
def friends(request):
    friends = Friends.objects.filter(Q(friend_id=request.user.id), Q(request=1))

    response = []
    for friend in friends:
        result = {}
        user = AuthUser.objects.get(pk=friend.owner_id)
        result['id'] = user.id
        result['name'] = NoneToStr(user.first_name) + ' ' + NoneToStr(user.last_name)
        result['avatar'] = NoneToStr(user.avatar)
        result['type'] = 'friends'

        cursor = connection.cursor()
        cursor.execute("""
            SELECT count(DISTINCT a.friend_id) as v_count FROM friends a
            join friends b
            on a.friend_id = b.friend_id
            and a.owner_id = {0}
            and b.owner_id = {1}
        """.format(request.user.id, user.id))
        mutual = cursor.fetchone()

        result['mutual_friend_count'] = mutual[0]

        response.append(result)

    return render(request, 'user/friend.html', {'friends': response})


def confirm_friend_request(request):
    if request.user.is_authenticated():
        if request.is_ajax():
            if request.POST:
                try:
                    with transaction.atomic():
                        friend_request = Friends.objects.get(Q(friend_id=request.user.id),
                                                             Q(owner_id=request.POST['user']),
                                                             Q(request=0))
                        try:
                            friend = Friends.objects.get(Q(friend_id=request.POST['user']), Q(owner_id=request.user.id))
                            friend.request = 1
                            friend_request.request = 1

                            friend.save()
                            friend_request.save()
                        except ObjectDoesNotExist:
                            friend = Friends(owner_id=request.user.id, friend_id=request.POST['user'], request=1)
                            friend_request.request = 1

                            friend.save()
                            friend_request.save()

                        return HttpResponse(json.dumps({'success': True}), content_type="application/json")
                except ObjectDoesNotExist:
                    return HttpResponse(json.dumps({'success': False, 'message': 'This user not sent friend request!'}),
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


def cancel_friend_request(request):
    if request.user.is_authenticated():
        if request.is_ajax():
            if request.POST:
                try:
                    with transaction.atomic():
                        friend_request = Friends.objects.get(Q(friend_id=request.user.id),
                                                             Q(owner_id=request.POST['user']),
                                                             Q(request=0))
                        try:
                            friend = Friends.objects.get(Q(friend_id=request.POST['user']), Q(owner_id=request.user.id))
                            friend.request = 2
                            friend_request.request = 2

                            friend.save()
                            friend_request.save()
                        except ObjectDoesNotExist:
                            friend_request.request = 2
                            friend_request.save()

                        return HttpResponse(json.dumps({'success': True}), content_type="application/json")
                except ObjectDoesNotExist:
                    return HttpResponse(json.dumps({'success': False, 'message': 'This user not sent friend request!'}),
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
def login_with_page(request, page_id=None):
    if page_id:
        my_pages = list(AuthUser.objects.values_list('id', flat=True).filter(parent_id=request.user.id))
        try:
            if int(page_id) in my_pages:
                user = authenticate(page_id=page_id)
                if user is not None:
                    auth.login(request, user)

                return redirect('home')
            elif int(page_id) == request.user.parent_id:
                user = authenticate(page_id=page_id)
                if user is not None:
                    auth.login(request, user)

                return redirect('home')
            else:
                raise Http404
        except:
            raise Http404
    else:
        redirect('home')