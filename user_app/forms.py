import datetime

from django import forms
from django.core.exceptions import ObjectDoesNotExist

from main_app.models import AuthUser


class RegistrationForm(forms.Form):
    first_name = forms.CharField(min_length=2)
    last_name = forms.CharField(min_length=2)
    email = forms.EmailField()
    birth_day = forms.IntegerField()
    birth_month = forms.IntegerField()
    birth_year = forms.IntegerField()
    gender = forms.IntegerField()
    password = forms.CharField(min_length=6)
    re_password = forms.CharField()

    # captcha = CaptchaField()
    def clean_email(self):
        cd = self.cleaned_data
        email = cd.get('email')
        try:
            AuthUser.objects.get(email=email)
            raise forms.ValidationError('This email already in use!')
        except ObjectDoesNotExist:
            pass

        return email

    def clean(self):
        cd = self.cleaned_data
        password = cd.get('password')
        re_password = cd.get('re_password')
        birth_day = cd.get('birth_day')
        birth_month = cd.get('birth_month')
        birth_year = cd.get('birth_year')
        gender = cd.get('gender')

        if password != re_password:
            raise forms.ValidationError('The passwords not equal!')

        try:
            if int(birth_day) not in range(1, 32):
                raise forms.ValidationError('Invalid day!')

            if int(birth_month) not in range(1, 13):
                raise forms.ValidationError('Invalid month!')

            if int(birth_year) not in range(1940, datetime.datetime.now().year + 1):
                raise forms.ValidationError('Invalid year!')

            if int(gender) not in [0, 1]:
                raise forms.ValidationError('Invalid gender!')
        except:
            raise forms.ValidationError('Incorrect date in birthday!')

        return cd