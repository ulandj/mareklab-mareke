from main_app.models import Maareke, Post, Video, Photo, Comment, AuthUser


def maareke_object_item_exist(object_type, object_id):
    try:
        if int(object_type) in [0, 1]:
            user = AuthUser.objects.get(pk=object_id)
        elif int(object_type) == 2:
            maareke = Maareke.objects.get(pk=object_id)
        elif int(object_type) == 3:
            post = Post.objects.get(pk=object_id)
        elif int(object_type) == 4:
            video = Video.objects.get(pk=object_id)
        elif int(object_type) == 5:
            photo = Photo.objects.get(pk=object_id)
        elif int(object_type) == 6:
            comment = Comment.objects.get(pk=object_id)

        return True
    except:
        return False


def get_maareke_object_owner(object_type, object_id):
    try:
        owner = None

        if int(object_type) in [0, 1]:
            owner = int(object_id)
        elif int(object_type) == 2:
            maareke = Maareke.objects.get(pk=object_id)
            owner = maareke.husband_id
        elif int(object_type) == 3:
            post = Post.objects.get(pk=object_id)
            owner = post.owner_id
        elif int(object_type) == 4:
            video = Video.objects.get(pk=object_id)
            owner = video.owner_id
        elif int(object_type) == 5:
            photo = Photo.objects.get(pk=object_id)
            owner = photo.owner_id
        elif int(object_type) == 6:
            comment = Comment.objects.get(pk=object_id)
            owner = comment.owner_id

        return owner
    except:
        return None