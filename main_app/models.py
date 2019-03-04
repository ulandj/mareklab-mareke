import uuid

from django.db import connection
from django.db import models


class Albums(models.Model):
    id = models.AutoField(primary_key=True)
    owner_id = models.IntegerField()
    title = models.CharField(max_length=100, default='My Album')
    description = models.TextField(blank=True, null=True)
    datetime = models.DateTimeField(auto_now_add=True)
    applause_count = models.IntegerField(default=0)
    maareke_id = models.IntegerField(blank=True, null=True)
    album_type = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'album'


class Applause(models.Model):
    id = models.AutoField(primary_key=True)
    from_user = models.IntegerField()
    to_user = models.IntegerField()
    object_type = models.IntegerField()
    object_id = models.IntegerField()
    datetime = models.DateTimeField(auto_now_add=True)

    class Meta:
        managed = False
        db_table = 'applause'


class Attendence(models.Model):
    id = models.IntegerField(primary_key=True)
    maareke_id = models.IntegerField(blank=True, null=True)
    user_id = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'attendence'


class AuthGroup(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(unique=True, max_length=80)

    class Meta:
        managed = False
        db_table = 'auth_group'


class AuthGroupPermissions(models.Model):
    id = models.IntegerField(primary_key=True)
    group = models.ForeignKey(AuthGroup)
    permission = models.ForeignKey('AuthPermission')

    class Meta:
        managed = False
        db_table = 'auth_group_permissions'


class AuthPermission(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=50)
    content_type = models.ForeignKey('DjangoContentType')
    codename = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'auth_permission'


class AuthUser(models.Model):
    id = models.AutoField(primary_key=True)
    fb_id = models.BigIntegerField(blank=True, null=True)
    email = models.CharField(max_length=75)
    password = models.CharField(max_length=128)
    first_name = models.CharField(max_length=30)
    last_name = models.CharField(max_length=50)
    birthday = models.DateField(blank=True, null=True)
    country = models.IntegerField(blank=True, null=True)
    region = models.IntegerField(blank=True, null=True)
    gender = models.IntegerField(blank=True, null=True)
    marital_status = models.IntegerField(blank=True, null=True)
    avatar = models.IntegerField(blank=True, null=True)
    wallpaper = models.IntegerField(blank=True, null=True)
    is_superuser = models.IntegerField(null=False, default=0)
    is_staff = models.IntegerField(default=1)
    is_active = models.IntegerField(null=False, default=0)
    activation_code = models.CharField(max_length=255, blank=True, null=True)
    last_login = models.DateTimeField()
    date_joined = models.DateTimeField(auto_now_add=True)
    username = models.CharField(max_length=30)
    token = models.CharField(max_length=255)
    user_channel = models.CharField(max_length=255, blank=True, null=True)
    parent_id = models.IntegerField(blank=True, null=True)
    page_type = models.IntegerField(blank=True, null=True)
    address = models.TextField(blank=True, null=True)
    description = models.TextField(blank=True, null=True)
    phone = models.CharField(max_length=50, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'auth_user'


class AuthUserGroups(models.Model):
    id = models.IntegerField(primary_key=True)
    user = models.ForeignKey(AuthUser)
    group = models.ForeignKey(AuthGroup)

    class Meta:
        managed = False
        db_table = 'auth_user_groups'


class AuthUserUserPermissions(models.Model):
    id = models.IntegerField(primary_key=True)
    user = models.ForeignKey(AuthUser)
    permission = models.ForeignKey(AuthPermission)

    class Meta:
        managed = False
        db_table = 'auth_user_user_permissions'


class Comment(models.Model):
    id = models.AutoField(primary_key=True)
    owner_id = models.IntegerField()
    text = models.TextField()
    datetime = models.DateTimeField(auto_now_add=True)
    object_type = models.IntegerField()
    object_id = models.IntegerField()
    applause_count = models.IntegerField(default=0)

    class Meta:
        managed = False
        db_table = 'comment'


class DjangoAdminLog(models.Model):
    id = models.IntegerField(primary_key=True)
    action_time = models.DateTimeField()
    user = models.ForeignKey(AuthUser)
    content_type = models.ForeignKey('DjangoContentType', blank=True, null=True)
    object_id = models.TextField(blank=True)
    object_repr = models.CharField(max_length=200)
    action_flag = models.IntegerField()
    change_message = models.TextField()

    class Meta:
        managed = False
        db_table = 'django_admin_log'


class DjangoContentType(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=100)
    app_label = models.CharField(max_length=100)
    model = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'django_content_type'


class DjangoSession(models.Model):
    session_key = models.CharField(primary_key=True, max_length=40)
    session_data = models.TextField()
    expire_date = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_session'


class Friends(models.Model):
    id = models.AutoField(primary_key=True)
    owner_id = models.IntegerField()
    friend_id = models.IntegerField()
    datetime = models.DateTimeField(auto_now_add=True)
    request = models.IntegerField(default=0)

    class Meta:
        managed = False
        db_table = 'friends'


class Maareke(models.Model):
    id = models.AutoField(primary_key=True)
    owner_id = models.IntegerField()
    title = models.CharField(max_length=255)
    description = models.TextField()
    location = models.TextField()
    country = models.IntegerField()
    region = models.IntegerField()
    event_date = models.DateField()
    event_time = models.TimeField()
    applause_count = models.IntegerField(default=0)
    attend_count = models.IntegerField(default=0)
    class Meta:
        managed = False
        db_table = 'maareke'


class DataType(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=255)
    class Meta:
        managed = False
        db_table = 'data_type'


class PageProperty(models.Model):
    id = models.AutoField(primary_key=True)
    page_id = models.IntegerField()
    page_type_property_id = models.IntegerField()
    value = models.CharField(max_length=255, blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'page_property'


class PageType(models.Model):
    id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=255)
    sort = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'page_type'


class PageTypeProperty(models.Model):
    id = models.IntegerField(primary_key=True)
    page_type_id = models.IntegerField()
    data_type_id = models.IntegerField()
    title = models.CharField(max_length=100)
    default_value = models.TextField(blank=True)
    required = models.BooleanField(default=True)
    class Meta:
        managed = False
        db_table = 'page_type_property'


class Photo(models.Model):
    id = models.AutoField(primary_key=True)
    owner_id = models.IntegerField()
    title = models.CharField(max_length=255)
    album_id = models.IntegerField()
    datetime = models.DateTimeField(auto_now_add=True)
    description = models.CharField(max_length=255)
    applause_count = models.IntegerField(default=0)

    class Meta:
        managed = False
        db_table = 'photo'


class Post(models.Model):
    id = models.AutoField(primary_key=True)
    owner_id = models.IntegerField()
    description = models.TextField()
    datetime = models.DateTimeField(auto_now_add=True)
    applause_count = models.IntegerField(default=0)
    public = models.IntegerField(default=0)

    class Meta:
        managed = False
        db_table = 'post'


def get_file_path(filename):
    ext = filename.split('.') - 1
    filename = "%s.%s" % (uuid.uuid4(), ext)
    return filename


class Video(models.Model):
    id = models.AutoField(primary_key=True)
    owner_id = models.IntegerField()
    description = models.TextField()
    datetime = models.DateTimeField(auto_now_add=True)
    applause_count = models.IntegerField(default=0)
    maareke_id = models.IntegerField(blank=True, null=True)
    original_file = models.FileField(upload_to='media')
    converted_file = models.CharField(max_length=255)
    is_converted = models.BooleanField(default=False)

    class Meta:
        managed = False
        db_table = 'video'


class Region(models.Model):
    id = models.IntegerField(primary_key=True)
    parent_id = models.IntegerField(blank=True, null=True)
    title = models.CharField(max_length=255)
    type = models.IntegerField()

    @staticmethod
    def getParents(child_id):
        # create a cursor
        cur = connection.cursor()
        # execute the stored procedure passing in
        # search_string as a parameter
        # cur.callfunc('GetParents', [child_id,])
        # grab the results
        cur.execute("SELECT GetParents(%s) FROM dual", [child_id])
        results = cur.fetchone()
        cur.close()

        # wrap the results up into Document domain objects
        return [int(id) if id != '' else id for id in results[0].split(',')]

    class Meta:
        managed = False
        db_table = 'region'


class RegionType(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=255)

    class Meta:
        managed = False
        db_table = 'region_type'


class Message(models.Model):
    id = models.AutoField(primary_key=True)
    from_user = models.IntegerField()
    to_user = models.IntegerField()
    text = models.TextField()
    create_date = models.DateTimeField(auto_now_add=True)
    is_read = models.IntegerField(default=True)

    class Meta:
        managed = False
        db_table = 'message'


class Timeline(models.Model):
    id = models.AutoField(primary_key=True)
    friend_id = models.IntegerField(blank=True, null=True)
    owner_id = models.IntegerField()
    datetime = models.DateTimeField(auto_now_add=True)
    action_type = models.IntegerField()
    action_id = models.IntegerField(blank=True, null=True)
    object_type = models.IntegerField()
    object_id = models.IntegerField()
    friend_name = models.CharField(max_length=255, blank=True, null=True)
    friend_avatar = models.CharField(max_length=255, blank=True, null=True)
    owner_name = models.CharField(max_length=255)
    owner_avatar = models.CharField(max_length=255, null=True)
    object_title = models.CharField(max_length=255, blank=True, null=True)
    object_description = models.TextField(null=True)
    object_datetime = models.DateTimeField(auto_now_add=True)
    object_file_url = models.CharField(max_length=255, blank=True, null=True)
    public = models.IntegerField(default=0)
    is_ready_to_show = models.IntegerField(default=True)

    class Meta:
        managed = False
        db_table = 'timeline'