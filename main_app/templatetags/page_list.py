from django import template
from main_app.models import AuthUser, PageType

register = template.Library()


@register.inclusion_tag('maareke/page_list.html')
def print_page_list(owner_id):
    try:
        user = AuthUser.objects.get(pk=owner_id)
        if user.parent_id:
            pages = AuthUser.objects.filter(pk=user.parent_id)
        else:
            pages = AuthUser.objects.filter(parent_id=owner_id)
    except:
        pages = None


    return {'pages': pages}


@register.inclusion_tag('maareke/menu_page_types.html')
def print_page_types():
    try:
        page_types = PageType.objects.order_by('sort')
    except:
        page_types = None


    return {'page_types': page_types}