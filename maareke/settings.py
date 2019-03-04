# -*- coding: utf-8 -*-
"""
Django settings for maareke project.

For more information on this file, see
https://docs.djangoproject.com/en/1.6/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/1.6/ref/settings/
"""

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
import os

from authomatic.providers import oauth2
from authomatic import Authomatic


BASE_DIR = os.path.dirname(os.path.dirname(__file__))


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/1.6/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = '_6_yya!@7a$+a8b)xzkolvdkem2k69#h8hy&0cxzurwuwdglg+'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

TEMPLATE_DEBUG = True

ALLOWED_HOSTS = []


# Application definition

INSTALLED_APPS = (
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'main_app.templatetags',
    'statici18n',
    'main_app',
)

MIDDLEWARE_CLASSES = (
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'django.middleware.locale.LocaleMiddleware',
)


ROOT_URLCONF = 'maareke.urls'

WSGI_APPLICATION = 'maareke.wsgi.application'


# Database
# https://docs.djangoproject.com/en/1.6/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'maareke_db',
        'USER': 'root',
        'PASSWORD': '',
        'HOST': '127.0.0.1',
        'PORT': '3306',
    }
}

# Internationalization
# https://docs.djangoproject.com/en/1.6/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_L10N = True

USE_TZ = True

LANGUAGES = (
    ('en', 'English'),
    ('ru', 'Русский'),
    ('kg', 'Кыргызча'),
)

LOCALE_PATHS = (
    os.path.join(BASE_DIR, 'locale'),
)

# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/1.6/howto/static-files/

STATIC_URL = '/static/'
STATICFILES_DIRS = (os.path.join(BASE_DIR, 'static'), )
STATICI18N_ROOT = STATICFILES_DIRS[0]

TEMPLATE_DIRS = os.path.join(BASE_DIR, 'templates')

FB_LOGOUT_REDIRECT='http://54.186.10.240'

CONFIG = {
    'fb': {
        'class_': oauth2.Facebook,

        # Facebook is an AuthorizationProvider too.
        'consumer_key': '711574488899054',
        'consumer_secret': '3ab4d7cd8d7143754523a085d1d878ac',

        # But it is also an OAuth 2.0 provider and it needs scope.
        'scope': ['user_about_me', 'email', 'publish_stream'],
    }
}

FB_AUTHOMATIC = Authomatic(CONFIG, SECRET_KEY)

AUTHENTICATION_BACKENDS = ('backends.AuthBackend.Auth', 'backends.AuthBackend.FBAuth', 'backends.AuthBackend.PageAuth')

MEDIA_ROOT = os.path.join('', '')
MEDIA_URL = '/media/'

DATE_INPUT_FORMATS = ['%Y-%m-%d', '%d/%m/%Y', '%d-%m-%Y']
TIME_INPUT_FORMATS = ['%H:%M']

