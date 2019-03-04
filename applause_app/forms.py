from django import forms
from django.core.exceptions import ObjectDoesNotExist
from django.db.models import Q

from main_app.models import Applause, AuthUser
from main_app.utils import MAAREKE_OBJECT


class ApplauseForm(forms.Form):
    from_user = forms.IntegerField()
    to_user = forms.IntegerField()
    object_type = forms.IntegerField()
    object_id = forms.IntegerField()

    def clean(self):
        cd = self.cleaned_data
        object_type = cd.get('object_type')
        object_id = cd.get('object_id')
        from_user = cd.get('from_user')
        to_user = cd.get('to_user')

        if int(object_type) not in list(MAAREKE_OBJECT.values()):
            raise forms.ValidationError('Invalid maareke object!')

        try:
            applause = Applause.objects.get(Q(from_user=from_user), Q(to_user=to_user), Q(object_type=object_type),
                                            Q(object_id=object_id))
            raise forms.ValidationError('You already applause!')
        except ObjectDoesNotExist:
            pass

        try:
            from_user_exist = AuthUser.objects.get(pk=from_user)
        except ObjectDoesNotExist:
            raise forms.ValidationError('User/Page not exist!')


        try:
            from_user_exist = AuthUser.objects.get(pk=to_user)
        except ObjectDoesNotExist:
            raise forms.ValidationError('User/Page not exist!')

        return cd