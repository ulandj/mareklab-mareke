import traceback
from django.contrib.auth.hashers import check_password

from django.contrib.auth.models import User
from django.db.models import Q
from main_app.models import AuthUser
from main_app.utils import getUserToken


class Auth(object):
    def authenticate(self, email=None, password=None):
        try:
            user = AuthUser.objects.get(Q(email=email), Q(parent_id__isnull=True))
            if check_password(password, user.password):
                os_user = User.objects.get(pk=user.id)

                user.token = getUserToken(user.email)
                user.save()

                return os_user

            return None
        except:
            print(traceback.format_exc())
            return None

    def get_user(self, user_id):
        try:
            return User.objects.get(pk=user_id)
        except User.DoesNotExist:
            return None


class FBAuth(object):
    def authenticate(self, fb_id=None):
        try:
            fb_user = AuthUser.objects.get(fb_id=fb_id)

            os_user = User.objects.get(pk=fb_user.id)

            fb_user.token = getUserToken(fb_user.email)
            fb_user.save()

            return os_user
        except:
            print(traceback.format_exc())
            return None

    def get_user(self, user_id):
        try:
            return User.objects.get(pk=user_id)
        except User.DoesNotExist:
            return None


class PageAuth(object):
    def authenticate(self, page_id=None):
        try:
            user = AuthUser.objects.get(id=page_id)
            os_user = User.objects.get(pk=user.id)

            user.token = getUserToken(user.email)
            user.save()

            return os_user
        except:
            print(traceback.format_exc())
            return None

    def get_user(self, user_id):
        try:
            return User.objects.get(pk=user_id)
        except User.DoesNotExist:
            return None