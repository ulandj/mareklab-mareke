from django import forms


class CommentAddForm(forms.Form):
    object_type = forms.IntegerField()
    text = forms.CharField()
    object_id = forms.IntegerField()


class CommentGetForm(forms.Form):
    object_type = forms.IntegerField()
    object_id = forms.IntegerField()


class CommentDeleteForm(forms.Form):
    object_type = forms.IntegerField()
    object_id = forms.IntegerField()
    comment_id = forms.IntegerField()