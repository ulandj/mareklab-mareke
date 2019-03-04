from django import template
from django.db.models import Q
from main_app.models import Friends

register = template.Library()

@register.filter
def friend_request_count(owner_id):
    try:
        friend_req_count = Friends.objects.filter(Q(friend_id=owner_id), Q(request=0)).count()
    except:
        friend_req_count = 0

    return friend_req_count