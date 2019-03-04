from django.conf.urls import patterns, include, url

from django.contrib import admin
from django.contrib.auth.decorators import login_required
from maareke_app.views import GetPageFieldsView

admin.autodiscover()

# MAIN
urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'maareke.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),

    url(r'^admin/', include(admin.site.urls)),
    url(r'^get_last_posts/$', 'main_app.views.main_page_posts'),
    url(r'^search_data/(?P<text>.+)/$', 'main_app.views.search_data'),
)


# USERS
urlpatterns += patterns('',
    url(r'^$', 'main_app.views.home_page', name='home'),
    url(r'^login/$', 'user_app.views.login'),
    url(r'^fb_login/$', 'user_app.views.fb_login'),
    url(r'^page_login/(?P<page_id>[0-9]{1,11})/$', 'user_app.views.login_with_page'),
    url(r'^register/$', 'user_app.views.register'),
    url(r'^activation/$', 'user_app.views.register_activation'),
    url(r'^logout/$', 'user_app.views.user_logout'),
    url(r'^user/(?P<user_id>[0-9]{1,11})/$', 'user_app.views.another_user_home'),
    url(r'^add_friend/$', 'user_app.views.add_friend'),
    url(r'^friend_requests/$', 'user_app.views.friend_request_page'),
    url(r'^friends/$', 'user_app.views.friends'),
    url(r'^confirm_friend_request/$', 'user_app.views.confirm_friend_request'),
    url(r'^cancel_friend_request/$', 'user_app.views.cancel_friend_request'),
)


# APPLAUSE
urlpatterns += patterns('',
    url(r'^applause/$', 'applause_app.views.applause'),
)


# COMMENTS
urlpatterns += patterns('',
    url(r'^get_comments/$', 'comment_app.views.get_comments'),
    url(r'^add_comment/$', 'comment_app.views.add_comment'),
    url(r'^delete_comment/$', 'comment_app.views.delete_comment'),
)


# POSTS
urlpatterns += patterns('',
    url(r'^share_text/$', 'post_app.views.share_text_post'),
    url(r'^share_photo/$', 'post_app.views.share_photo_post'),
    url(r'^share_video/$', 'post_app.views.share_video_post'),
)


# MAAREKE
urlpatterns += patterns('',
    url(r'^create_maareke/$', 'maareke_app.views.create_maareke'),
    url(r'^get_page_fields/$', login_required(GetPageFieldsView.as_view())),
    url(r'^create_page/$', 'maareke_app.views.create_page'),
    url(r'^get_page_list/$', 'maareke_app.views.get_page_list'),
    url(r'^share_event/$', 'maareke_app.views.create_event'),
)


# MESSAGE
urlpatterns += patterns('',
    url(r'^message/$', 'message_app.views.index'),
    url(r'^get_messages/$', 'message_app.views.get_messages'),
)