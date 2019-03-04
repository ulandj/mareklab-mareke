from django import forms
from django.template.defaultfilters import filesizeformat


class ShareTextForm(forms.Form):
    share_text = forms.CharField(widget=forms.Textarea, max_length=1000)
    share_public = forms.IntegerField()

    def clean(self):
        cd = self.cleaned_data
        share_public = cd.get('share_public')

        if int(share_public) not in [0, 1]:
            raise forms.ValidationError('Incorrect public value!')

        return cd


class SharePhotoForm(forms.Form):
    share_photo_desc = forms.CharField(widget=forms.Textarea, max_length=1000)
    filePhoto = forms.ImageField()
    share_public = forms.IntegerField()

    def clean(self):
        cd = self.cleaned_data
        share_public = cd.get('share_public')

        if int(share_public) not in [0, 1]:
            raise forms.ValidationError('Incorrect public value!')

        return cd


class ShareVideoForm(forms.Form):
    share_video_desc = forms.CharField(widget=forms.Textarea, max_length=1000)
    video_file = forms.FileField()
    share_public = forms.IntegerField()

    def clean(self):
        cd = self.cleaned_data
        video_file = cd.get('video_file')
        share_public = cd.get('share_public')

        if int(share_public) not in [0, 1]:
            raise forms.ValidationError('Incorrect public value!')

        try:
            size = video_file._size

            content_type = video_file.content_type
            if content_type in ['video/avi', 'video/mp4', 'video/webm', 'video/x-ms-wmv', 'video/x-flv',
                                'video/mpeg', ]:
                if video_file._size > 639631360:
                    raise forms.ValidationError('Please keep filesize under %s. Current filesize %s') % (
                        filesizeformat(self.max_upload_size), filesizeformat(video_file._size))
            else:
                raise forms.ValidationError('Filetype not supported.')

        except AttributeError:
            pass

        return cd