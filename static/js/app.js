function getCookie(name) {
    var cookieValue = null;
    if (document.cookie && document.cookie != '') {
        var cookies = document.cookie.split(';');
        for (var i = 0; i < cookies.length; i++) {
            var cookie = jQuery.trim(cookies[i]);
            // Does this cookie string begin with the name we want?
            if (cookie.substring(0, name.length + 1) == (name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    return cookieValue;
}

function showSuccessToast(text) {
    notif({
        msg: text,
        type: "success",
        position: "center",
        timeout: 5000,
        multiline: true
    });
}

function showWarningToast(text) {
    notif({
        msg: text,
        type: "warning",
        position: "center",
        timeout: 5000,
        multiline: true
    });
}

function showErrorToast(text) {
    notif({
        msg: text,
        type: "error",
        position: "center",
        timeout: 5000,
        multiline: true
    });
}

function show_share_main(param) {
    $('#share_' + param).hide();
    $('#share_main').fadeIn('slow', function () {
    });
}

function hide_share_main(param) {
    $('#share_main').hide();
    $('#share_' + param).fadeIn('slow', function () {
    });
}


function readURL(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function (e) {
            $('#previewHolder').attr('src', e.target.result);
        }

        reader.readAsDataURL(input.files[0]);
    }
}

(function ($) {
    $.fn.extended_itf = function () {
        if (/msie/.test(navigator.userAgent.toLowerCase())) return;
        this.each(function () {
            var obj = $(this);
            var placeholder = obj.is('[placeholder]') ? obj.attr('placeholder') : 'no file selected';
            var upload_value = $('<div class="upload_value"/>').html('<div>' + placeholder + '</div>');
            var upload_button = $('<div class="upload_button"/>');
            obj.wrap('<label class="upload_file"/>');
            obj.parent().append(upload_value);
            obj.parent().append(upload_button);
            obj.change(function () {
                upload_value.find('div').text($(this).val());
            });
        });
    };
})(jQuery);


//////////////////////////////////////////////
//               MESSAGE SCRIPTS           //
/////////////////////////////////////////////

function disconnect() {
    if (window.socket_conn != null) {
        window.socket_conn.close();
        window.socket_conn = null;
    }
}


function sendCommand(command) {
    if (command) {
        window.socket_conn.send(
            JSON.stringify(
                command
            )
        );
    }
}


function updateUserStatuses() {
    var users = [];
    $('.msg-frnd-avatar').children('.status').each(function (index) {
        users.push(parseInt($(this).attr('data-user')));
    });

    var user_status = {
        "command": 'online',
        "token": window.user_socket_token,
        "users": users
    };

    sendCommand(user_status);
}


function sendMessage(to_user, message_value) {
    if (to_user && message_value) {
        var message = {
            'command': 'echo',
            'value': {
                'to': to_user,
                'message': message_value
            },

            'token': window.user_socket_token
        };

        sendCommand(message);

        return true;
    }

    return false;
}


$(document).ready(function () {
        window.socket_conn = null;

        new_conn = function () {
            disconnect();

            window.socket_conn = new SockJS('http://54.186.10.240:8080/chat');

            window.socket_conn.onopen = function () {
                window.socket_conn.send(JSON.stringify(
                    {
                        'command': 'auth',
                        'token': window.user_socket_token
                    }
                ));
            };

            window.socket_conn.onmessage = function (e) {
                if ((e.data['response'] == 'online') && (window.location.pathname.split("/")[1] == 'message')) {
                    $('.msg-frnd-avatar').children('.status').each(function (index) {
                        current_user_id = $(this).attr('data-user');
                        onlines_arr = $.map(e.data['online'], function (el) {
                            return el;
                        });

                        if ($.inArray(parseInt(current_user_id), onlines_arr) > -1) {
                            $(this).removeClass('ofline');
                            $(this).addClass('online');
                        } else {
                            $(this).removeClass('online');
                            $(this).addClass('ofline');
                        }
                    });
                }

                else if (e.data['response'] == 'own_message') {
                    my_name = e.data['from']['first_name'] + ' ' + e.data['from']['last_name'];
                    my_id = e.data['from']['id'];

                    $('.message-cont').animate({ scrollTop: $('.message-cont')[0].scrollHeight}, 0);

                    if ($('.msg-text').find('.msg-main-row').length != 0) {
                        last_child = $('.msg-text').children('.msg-main-row').last();

                        last_user = last_child.attr('owner');


                        if (parseInt(last_user) == parseInt(my_id)) {
                            last_child.find('.msg-main-text').append('<p>' + e.data['message'] + '</p>');
                        } else {
                            $clone = $('#message_row').clone();

                            $clone.removeAttr('style');
                            $clone.removeAttr('id');

                            $clone.attr('owner', e.data['from']['id']);

                            $clone.find('.msg-user-name').find('p').html(my_name);
                            $clone.find('.cont-time').html(e.data['from']['datetime']);
                            $clone.find('.msg-main-text').find('p').html(e.data['message']);

                            $('.msg-text').append($clone);
                        }
                    } else {
                        $clone = $('#message_row').clone();

                        $clone.removeAttr('style');
                        $clone.removeAttr('id');

                        $clone.attr('owner', e.data['from']['id']);

                        $clone.find('.msg-user-name').find('p').html(my_name);
                        $clone.find('.cont-time').html(e.data['from']['datetime']);
                        $clone.find('.msg-main-text').find('p').html(e.data['message']);

                        $('.msg-text').append($clone);
                    }
                }

                else if (e.data['response'] == 'new') {
                    $('#chatAudio')[0].play();
                    if (window.location.pathname.split("/")[1] == 'message') {
                        $('.message-cont').animate({ scrollTop: $('.message-cont')[0].scrollHeight}, 0);
                        from_name = $.trim(e.data['from']['first_name'] + ' ' + e.data['from']['last_name']);
                        from_id = e.data['from']['id'];
                        open_window_owner = $('.msg-owner').attr('owner');

                        if (parseInt(open_window_owner) == parseInt(from_id)) {

                            if ($('.msg-text').find('.msg-main-row').length != 0) {
                                last_child = $('.msg-text').children('.msg-main-row').last();

                                last_user = last_child.attr('owner');


                                if (parseInt(last_user) == parseInt(from_id)) {
                                    last_child.find('.msg-main-text').append('<p>' + e.data['message'] + '</p>');
                                } else {
                                    $clone = $('#message_row').clone();

                                    $clone.removeAttr('style');
                                    $clone.removeAttr('id');

                                    $clone.attr('owner', e.data['from']['id']);

                                    $clone.find('.msg-user-name').find('p').html(from_name);
                                    $clone.find('.cont-time').html(e.data['from']['datetime']);
                                    $clone.find('.msg-main-text').find('p').html(e.data['message']);

                                    $('.msg-text').append($clone);
                                }
                            } else {
                                $clone = $('#message_row').clone();

                                $clone.removeAttr('style');
                                $clone.removeAttr('id');

                                $clone.attr('owner', e.data['from']['id']);

                                $clone.find('.msg-user-name').find('p').html(from_name);
                                $clone.find('.cont-time').html(e.data['from']['datetime']);
                                $clone.find('.msg-main-text').find('p').html(e.data['message']);

                                $('.msg-text').append($clone);
                            }
                        } else {
                            $('.msg-frnd-avatar').children('.status').each(function (index) {
                                curr_user = $(this).attr('data-user');
                                if (parseInt(curr_user) == parseInt(e.data['from']['id'])) {
                                    if ($(this).children().length > 0) {
                                        message_count = isNaN(parseInt($(this).find('p').html())) ? 0 : parseInt($(this).find('p').html());
                                        message_count = message_count + 1;
                                        $(this).find('p').html(message_count);
                                    } else {
                                        $(this).append('<p>' + 1 + '</p>');
                                    }
                                }
                            });

                            if (typeof $('.message-header').find('.msg-con').html() === "undefined") {
                                $('.message-header').append('<p class="msg-con">' + 1 + '</p>');
                            } else {
                                total_msg = isNaN(parseInt($('.message-header').find('.msg-con').html())) ? 0 : parseInt($('.message-header').find('.msg-con').html());
                                total_msg = total_msg + 1;

                                $('.message-header').find('.msg-con').html(total_msg);
                            }

                            if (typeof $('#header_total_message').find('p').html() === "undefined") {
                                $('#header_total_message').append('<p>1</p>');
                            } else {
                                total_msg = isNaN(parseInt($('#header_total_message').find('p').html())) ? 0 : parseInt($('#header_total_message').find('p').html());
                                total_msg = total_msg + 1;

                                $('#header_total_message').find('p').html(total_msg);
                            }
                        }
                    } else {
                        if (typeof $('#header_total_message').find('p').html() === "undefined") {
                            $('#header_total_message').append('<p>1</p>');
                        } else {
                            total_msg = isNaN(parseInt($('#header_total_message').find('p').html())) ? 0 : parseInt($('#header_total_message').find('p').html());
                            total_msg = total_msg + 1;

                            $('#header_total_message').find('p').html(total_msg);
                        }
                    }
                }


                else if ((e.data['response'] == 'typing') && (window.location.pathname.split("/")[1] == 'message')) {
                    if (parseInt(e.data['from']['id']) == parseInt($('.msg-owner').attr('owner'))) {
                        if ($('#typing').children('p').length <= 0) {
                            $('#typing').html('<p><i class="icon-quill"></i>' + e.data['from']['first_name'] + ' is Typing</p>');
                            window.setTimeout(function () {
                                $('#typing').html('');
                            }, 2000);
                        }
                    }
                }
            }; //end onmessage

            window.socket_conn.onclose = function () {
                new_conn();
            };
        };

        new_conn();


        $(window).bind('scroll', function () {
            if ($(document).scrollTop() > 100) {
                $('#back-top').fadeIn();
            } else {
                $('#back-top').fadeOut();
            }
        });

        $('#back-top').hide();
        $('#back-top a').click(function () {
            $('body,html').animate({
                scrollTop: 0
            }, 800);

            return false;
        });

        $('.text_autosize').autosize();

        // open file dialog when click on image
        $('#click_upload').click(function () {
            $('#filePhoto').trigger('click');
        });

        // Photo preview
        $("#filePhoto").change(function () {
            readURL(this);
            $('.up-cont').hide();
        });


        $('#share_text_form').ajaxForm({
            // dataType identifies the expected content type of the server response
            dataType: 'json',
            resetForm: true,

            // success identifies the function to invoke when the server response
            // has been received
            success: function (data) {
                if (data.success) {
                    location.href = "/";
                } else {
                    showErrorToast(data.message)
                }
            }
        });

        $('#share_photo_form').ajaxForm({
            // dataType identifies the expected content type of the server response
            dataType: 'json',
            uploadProgress: function (event, position, total, percentComplete) {
                $('#share_photo').find('.upload-btn').hide();
                $('#share_photo').find('.load').show();
            },

            // success identifies the function to invoke when the server response
            // has been received
            success: function (data) {
                if (data.success) {
                    $('#previewHolder').attr('src', '/static/img/photo-upl-bg.png');
                    show_share_main('photo');
                    $('.up-cont').show();

                    $('#share_photo_form').resetForm();
                    showSuccessToast('Your photo post successfully uploaded!');
                } else {
                    $('#previewHolder').attr('src', '/static/img/photo-upl-bg.png');
                    $('.up-cont').show();
                    showErrorToast(data.message)
                }
            },

            complete: function (xhr) {
                $('#share_photo').find('.upload-btn').show();
                $('#share_photo').find('.load').hide();
            }
        });

        var bar = $('.bar');
        var percent = $('.percent');
        $('#share_video_form').find('input[type="file"]').extended_itf();

        $('#share_video_form').ajaxForm({
            beforeSend: function () {
                var percentVal = '0%';
                bar.width(percentVal);
                percent.html(percentVal);
            },
            uploadProgress: function (event, position, total, percentComplete) {
                var percentVal = percentComplete + '%';
                bar.width(percentVal);
                percent.html(percentVal);
                $('#share_video_form').find('.upload-btn').children('input').hide();
                $('#share_video_form').find('.ajax_load').show();
            },
            success: function (data) {
                var percentVal = '100%';
                bar.width(percentVal);
                percent.html(percentVal);

                if (data.success) {
                    var percentVal = '0%';
                    bar.width(percentVal);
                    percent.html(percentVal);
//                $("#share_video_file").replaceWith($("#share_video_file").clone());
                    $('#share_video_form').find('.upload-btn').children('input').show();
                    $('#share_video_form').find('.ajax_load').hide();
                    $('#share_video_form').resetForm();
                    showSuccessToast('Your video successfully uploaded!');
                } else {
                    var percentVal = '0%';
                    bar.width(percentVal);
                    percent.html(percentVal);
                    $("#share_video_file").replaceWith($("#share_video_file").clone());
                    $('#share_video_form').find('.upload-btn').children('input').show();
                    $('#share_video_form').find('.ajax_load').hide();
                    showErrorToast(data.message);
                }
            },
            complete: function (xhr) {
                $('#share_video_form').find('.upload_value').find('div').html('no file selected');
            }
        });


        $('#share_event_form').ajaxForm({
            uploadProgress: function (event, position, total, percentComplete) {
                $('#share_event_form').find('.upload-btn').children('input').hide();
                $('#share_event_form').find('.ajax_load').show();
            },
            success: function (data) {
                if (data.success) {
                    $('#share_event_form').find('.upload-btn').children('input').show();
                    $('#share_event_form').find('.ajax_load').hide();
                    $('#share_event_form').resetForm();
                    location.href = "/";

                    showSuccessToast(data.message);
                } else {
                    var error = '';
                    for (var key in data.message) {
                        error = key + ': ' + data.message[key];
                        break;
                    }
                    showErrorToast(error);
                }
            },
            complete: function (xhr) {
                $('#share_event_form').find('.upload-btn').children('input').show();
                $('#share_event_form').find('.ajax_load').hide();
            }
        });


        $('#search_popup').hide();

        $('#search_text').keyup(function () {
            if ($('#search_text').val().length > 0) {
                $('#search_popup').show();
            } else {
                $('#search_popup').hide();
            }
        });

        $('#search_text').focusin(function () {
            if ($('#search_text').val().length > 0) {
                $('#search_popup').show();
            }
        });

        $('#search_container').click(function (e) {
            e.stopPropagation();
        });

        $(document).click(function () {
            $('#search_popup').hide();
            if (!$("#menu_settings").hasClass('menu_hidden')) {
                $("#menu_settings").addClass('menu_hidden');
            }

        });

        videojs.options.flash.swf = "http://vjs.zencdn.net/4.0.3/video-js.swf";

        $("#settings").click(function (event) {
            event.stopPropagation();

            if ($("#menu_settings").hasClass('menu_hidden')) {
                $("#menu_settings").removeClass('menu_hidden');
            } else {
                $("#menu_settings").addClass('menu_hidden');
            }
        });

        $("#menu_settings").click(function (event) {
            event.stopPropagation();
        });

        $('#event_time').clockpicker({
            autoclose: true,
            placement: 'right'
        });

        $('#event_date').datepicker({
            changeMonth: true,
            changeYear: true,
            dateFormat: 'yy-mm-dd'
        });
    }
)
;
