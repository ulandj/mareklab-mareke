from django import template
from django.db.models import Q

from main_app.models import PageType, Region, Message


register = template.Library()


@register.filter
def page_type_title(page_type_id):
    try:
        page_type = PageType.objects.get(pk=page_type_id)
        title = page_type.title
    except:
        title = ''

    return title


@register.filter
def get_country_name(country_id):
    try:
        country = Region.objects.get(pk=country_id)
        title = country.title
    except:
        title = ''

    return title


@register.filter
def get_region_name(region_id):
    try:
        region = Region.objects.get(pk=region_id)
        title = region.title
    except:
        title = ''

    return title

@register.filter
def not_read_message_count(owner_id):
    try:
        message_count = Message.objects.filter(Q(to_user=owner_id), Q(is_read=0)).count()
    except:
        message_count = 0

    return message_count