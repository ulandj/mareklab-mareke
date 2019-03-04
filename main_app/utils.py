#coding: utf-8
from hashlib import md5
from datetime import datetime
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import smtplib

MAAREKE_OBJECT = {
    'user': 0,
    'page': 1,
    'maareke': 2,
    'post': 3,
    'video': 4,
    'photo': 5,
    'comment': 6,
    'event': 7
}

ACTION_TYPE = {
    'post': 1,
    'photo': 2,
    'video': 3,
    'comment': 4,
    'applause': 5,
    'event': 6
}


def NoneToStr(s):
    return '' if s is None else s


def datetime_from_str(time_str):
    """Return (<scope>, <datetime.datetime() instance>) for the given
    datetime string.

    >>> _datetime_from_str("2009")
    ('year', datetime.datetime(2009, 1, 1, 0, 0))
    >>> _datetime_from_str("2009-12")
    ('month', datetime.datetime(2009, 12, 1, 0, 0))
    >>> _datetime_from_str("2009-12-25")
    ('day', datetime.datetime(2009, 12, 25, 0, 0))
    >>> _datetime_from_str("2009-12-25 13")
    ('hour', datetime.datetime(2009, 12, 25, 13, 0))
    >>> _datetime_from_str("2009-12-25 13:05")
    ('minute', datetime.datetime(2009, 12, 25, 13, 5))
    >>> _datetime_from_str("2009-12-25 13:05:14")
    ('second', datetime.datetime(2009, 12, 25, 13, 5, 14))
    >>> _datetime_from_str("2009-12-25 13:05:14.453728")
    ('microsecond', datetime.datetime(2009, 12, 25, 13, 5, 14, 453728))
    """
    import time
    import datetime

    formats = [
        # <scope>, <pattern>, <format>
        ("year", "YYYY", "%Y"),
        ("month", "YYYY-MM", "%Y-%m"),
        ("day", "YYYY-MM-DD", "%Y-%m-%d"),
        ("day", "DD.MM.YYYY", "%d.%m.%Y"),
        ("day", "MM/DD/YYYY", "%m/%d/%Y"),
        ("hour", "YYYY-MM-DD HH", "%Y-%m-%d %H"),
        ("minute", "YYYY-MM-DD HH:MM", "%Y-%m-%d %H:%M"),
        ("second", "YYYY-MM-DD HH:MM:SS", "%Y-%m-%d %H:%M:%S"),
        # ".<microsecond>" at end is manually handled below
        ("microsecond", "YYYY-MM-DD HH:MM:SS", "%Y-%m-%d %H:%M:%S"),
    ]
    for scope, pattern, format in formats:
        if scope == "microsecond":
            # Special handling for microsecond part. AFAIK there isn't a
            # strftime code for this.
            if time_str.count('.') != 1:
                continue
            time_str, microseconds_str = time_str.split('.')
            try:
                microsecond = int((microseconds_str + '000000')[:6])
            except ValueError:
                continue
        try:
            # This comment here is the modern way. The subsequent two
            # lines are for Python 2.4 support.
            # t = datetime.datetime.strptime(time_str, format)
            t_tuple = time.strptime(time_str, format)
            t = datetime.datetime(*t_tuple[:6])
        except ValueError:
            pass
        else:
            if scope == "microsecond":
                t = t.replace(microsecond=microsecond)
            return scope, t
    else:
        raise ValueError("could not determine date from %r: does not "
                         "match any of the accepted patterns ('%s')"
                         % (time_str, "', '".join(s for s, p, f in formats)))


def send_email(receivers=[], title='', text=''):
    """
    Входящие параметры:
        receivers - список эл. адресов [example@example.kg, example1@example.kg]
        title - заголовок письма
        text - содержание письма

    Результат: True | False
    """

    if not receivers or title == '' or text == '':
        return False

    sender = 'udjamanbalaev@gmail.com'
    toaddr = ', '.join(receivers)
    subject = title

    try:
        server = smtplib.SMTP('smtp.gmail.com:587')
        try:
            server.starttls()
            server.login("udjamanbalaev", "ulan1986")

            msg = MIMEMultipart('alternative')
            msg['FROM'] = sender
            msg['To'] = toaddr
            msg['Subject'] = subject
            _attach = MIMEText(text, 'html', _charset='utf-8')
            msg.attach(_attach)

            server.sendmail(sender, receivers, msg.as_string())
        finally:
            server.quit()

        return True
    except smtplib.SMTPException:
        return False


def getNewEmailCode(p_salt_string='secret'):
    key = 'maareke312%$#' + str(p_salt_string) + str(datetime.now())

    return md5(key).hexdigest()


def getUserToken(p_salt_string='secret'):
    key = 'maareke%$#' + str(p_salt_string) + str(datetime.now())

    return md5(key).hexdigest()