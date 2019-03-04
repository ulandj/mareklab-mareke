from datetime import datetime
import json
import traceback

from django.contrib.auth.decorators import login_required
from django.db.models import Q
from django.http import HttpResponse
from django.shortcuts import render

from main_app.models import AuthUser, Message, Friends


@login_required
def index(request):
    try:
        last_message = Message.objects.filter(to_user=request.user.id).order_by('-create_date')[:1]
        if len(last_message) > 0:
            Message.objects.filter(
                Q(from_user=last_message[0].from_user), Q(to_user=request.user.id),
                Q(is_read=0)).update(is_read=1)

        response = {}

        users = Message.objects.raw("""
                  SELECT distinct
                          m.from_user id,
                          (
                            select concat(u.first_name, ' ', u.last_name)
                            from auth_user u
                            where u.id = m.from_user
                          ) user_name,
                          (
                            select isnull(u2.user_channel)
                            from auth_user u2
                            where u2.id = m.from_user
                          ) is_offline,
                          (
                            select count(mes.id)
                            from message mes
                            where mes.from_user = m.from_user
                            and mes.to_user = {0}
                            and mes.is_read = false
                          ) message_count,
                          (
                              select max(me.create_date)
                              from message me
                              where me.from_user = m.from_user
                              and me.to_user = {0}
                          ) create_date,
                          (
                            select me.text
                            from message me
                              where me.from_user = m.from_user
                              and me.to_user = {0}
                               order by me.create_date desc
                               limit 1 offset 0
                          ) last_message

                         FROM message m
                         WHERE m.to_user IN ({0})
                         ORDER BY create_date DESC
                         LIMIT 20 OFFSET 0
        """.format(request.user.id))

        msg_users = []
        for msg_user in users:
            msg_user_obj = {}
            msg_user_obj['id'] = msg_user.id
            msg_user_obj['user_name'] = msg_user.user_name
            msg_user_obj['is_offline'] = msg_user.is_offline
            msg_user_obj['message_count'] = msg_user.message_count

            try:
                if (datetime.strptime(str(msg_user.create_date), '%Y-%m-%d %H:%M:%S').year == datetime.now().year):
                    create_date = msg_user.create_date.strftime('%m-%d %H:%M')
                else:
                    create_date = msg_user.create_date.strftime('%Y-%m-%d %H:%M')
            except:
                print(traceback.format_exc())
                create_date = msg_user.create_date

            msg_user_obj['last_message_datetime'] = str(create_date)
            msg_user_obj['last_message'] = msg_user.last_message

            msg_users.append(msg_user_obj)

        if len(msg_users) < 20:
            msg_user_list = []
            for v_msg_user in msg_users:
                msg_user_list.append(int(v_msg_user['id']))

            if len(msg_user_list) > 1:
                friend_exclude = 'f.friend_id not in {0} and'.format(tuple(msg_user_list))
            elif len(msg_user_list) == 1:
                friend_exclude = 'f.friend_id <> {0} and'.format(msg_user_list[0])
            else:
                friend_exclude = ''

            query = """
                select f.friend_id id,
                          (
                            select concat(u.first_name, ' ', u.last_name)
                            from auth_user u
                            where u.id = f.friend_id
                          ) user_name,
                          (
                            select isnull(u2.user_channel)
                            from auth_user u2
                            where u2.id = f.friend_id
                          ) is_offline,
                          0 message_count,
                          '' create_date,
                          '' last_message
                from friends f
                where {0}  f.owner_id = {1}
                limit 20 offset 0
            """.format(friend_exclude, request.user.id)

            friend_users = Friends.objects.raw(query)

            for msg_user in friend_users:
                msg_user_obj = {}
                msg_user_obj['id'] = msg_user.id
                msg_user_obj['user_name'] = msg_user.user_name
                msg_user_obj['is_offline'] = msg_user.is_offline
                msg_user_obj['message_count'] = msg_user.message_count

                try:
                    if (datetime.strptime(str(msg_user.create_date), '%Y-%m-%d %H:%M:%S').year == datetime.now().year):
                        create_date = msg_user.create_date.strftime('%m-%d %H:%M')
                    else:
                        create_date = msg_user.create_date.strftime('%Y-%m-%d %H:%M')
                except:
                    create_date = msg_user.create_date

                msg_user_obj['last_message_datetime'] = str(create_date)
                msg_user_obj['last_message'] = msg_user.last_message

                msg_users.append(msg_user_obj)

        if len(msg_users) < 20:
            msg_user_list = []
            for v_msg_user in msg_users:
                msg_user_list.append(int(v_msg_user['id']))

            if len(msg_user_list) > 1:
                user_exclude = 'f.id not in {0} and'.format(tuple(msg_user_list))
            elif len(msg_user_list) == 1:
                user_exclude = 'f.id <> {0} and'.format(msg_user_list[0])
            else:
                user_exclude = ''

            query = """
                select f.id,
                       concat(f.first_name, ' ', f.last_name) user_name,
                       isnull(f.user_channel) is_offline,
                          0 message_count,
                          '' create_date,
                          '' last_message
                from auth_user f
                where {0}  f.id != {1}
                order by isnull(f.user_channel)
                limit 20 offset 0
            """.format(user_exclude, request.user.id)

            auth_users = AuthUser.objects.raw(query)

            for msg_user in auth_users:
                msg_user_obj = {}
                msg_user_obj['id'] = msg_user.id
                msg_user_obj['user_name'] = msg_user.user_name
                msg_user_obj['is_offline'] = msg_user.is_offline
                msg_user_obj['message_count'] = msg_user.message_count

                try:
                    if (datetime.strptime(str(msg_user.create_date), '%Y-%m-%d %H:%M:%S').year == datetime.now().year):
                        create_date = msg_user.create_date.strftime('%m-%d %H:%M')
                    else:
                        create_date = msg_user.create_date.strftime('%Y-%m-%d %H:%M')
                except:
                    create_date = msg_user.create_date

                msg_user_obj['last_message_datetime'] = str(create_date)
                msg_user_obj['last_message'] = msg_user.last_message

                msg_users.append(msg_user_obj)

        response['users'] = msg_users
        response['from_user'] = msg_users[0]

        return render(request, 'message/index.html', response)
    except:
        print(traceback.format_exc())
        return render(request, 'message/index.html')


def get_messages(request):
    if request.user.is_authenticated():
        if request.is_ajax():
            if request.POST:
                user_id = None
                try:
                    user_id = int(request.POST['user'])

                    Message.objects.filter(
                        Q(from_user=user_id), Q(to_user=request.user.id),
                        Q(is_read=0)).update(is_read=1)

                    messages = Message.objects.raw("""
                      select * from (
                                select m.*,
                                  (select concat(u.first_name, ' ', u.last_name)
                                  from auth_user u
                                  where u.id = m.from_user) from_name,

                                  (select concat(u.first_name, ' ', u.last_name)
                                  from auth_user u
                                  where u.id = m.to_user) to_name

                                from message m
                                where m.to_user in ({0}, {1})
                                  and m.from_user in ({0}, {1})
                                  order by m.create_date desc
                                  limit 20 offset 0
                          ) tab
                          order by create_date
                    """.format(request.user.id, user_id))

                    json_messages = []
                    for message in messages:
                        json_message = {}
                        json_message['id'] = message.from_user
                        json_message['from_name'] = message.from_name

                        if (int(message.create_date.strftime('%Y')) == datetime.now().year):
                            create_date = message.create_date.strftime('%m-%d %H:%M')
                        else:
                            create_date = message.create_date.strftime('%Y-%m-%d %H:%M')

                        json_message['create_date'] = str(create_date)
                        json_message['text'] = message.text

                        json_messages.append(json_message)

                    return HttpResponse(json.dumps({'success': True, 'messages': json_messages}),
                                        content_type="application/json")
                except:
                    print(traceback.format_exc())
                    return HttpResponse(json.dumps({'success': False, 'message': 'User not found!'}),
                                        content_type="application/json")
            else:
                response = {'success': False, 'message': 'Request must be a POST!'}
                return HttpResponse(json.dumps(response), content_type="application/json")
        else:
            return HttpResponse(json.dumps({'success': False, 'message': 'Its not ajax request!'}),
                                content_type="application/json")
    else:
        return HttpResponse(json.dumps({'success': False, 'message': 'You are not authenticated!'}),
                            content_type="application/json")