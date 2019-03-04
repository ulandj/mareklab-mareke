from django import forms
from maareke import settings


class CreatePageForm(forms.Form):
    page_type = forms.IntegerField()
    country = forms.IntegerField()
    region = forms.IntegerField()
    title = forms.CharField(min_length=3)
    phone_number = forms.CharField(min_length=3)
    address = forms.CharField(widget=forms.Textarea, min_length=5, max_length=1000)
    description = forms.CharField(widget=forms.Textarea, min_length=5, max_length=1000)


class CreateEventForm(forms.Form):
    title = forms.CharField(min_length=3)
    description = forms.CharField(widget=forms.Textarea, min_length=3)
    location = forms.CharField(widget=forms.Textarea, min_length=3)
    date = forms.DateField(input_formats=settings.DATE_INPUT_FORMATS)
    time = forms.TimeField(input_formats=settings.TIME_INPUT_FORMATS)
    share_public = forms.IntegerField()

    def clean(self):
        cd = self.cleaned_data
        share_public = cd.get('share_public')
        date = cd.get('date')
        time = cd.get('time')

        try:
            if int(share_public) not in [0, 1]:
                raise forms.ValidationError('Incorrect public value!')
        except:
            raise forms.ValidationError('Incorrect public value!')

        return cd