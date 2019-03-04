var ang_app = angular.module('ang_app', ['ngCookies', 'infinite-scroll', 'ui.router'], function ($locationProvider) {
    $locationProvider.hashPrefix = '';
})
    .config(function ($interpolateProvider, $httpProvider, $stateProvider, $urlRouterProvider) {
        $interpolateProvider.startSymbol('{[{');
        $interpolateProvider.endSymbol('}]}');

        $httpProvider.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded;charset=utf-8';
        $httpProvider.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';
        $httpProvider.defaults.transformRequest = [function (data) {
            /**
             * The workhorse; converts an object to x-www-form-urlencoded serialization.
             * @param {Object} obj
             * @return {String}
             */
            var param = function (obj) {
                var query = '';
                var name, value, fullSubName, subName, subValue, innerObj, i;

                for (name in obj) {
                    value = obj[name];

                    if (value instanceof Array) {
                        for (i = 0; i < value.length; ++i) {
                            subValue = value[i];
                            fullSubName = name + '[' + i + ']';
                            innerObj = {};
                            innerObj[fullSubName] = subValue;
                            query += param(innerObj) + '&';
                        }
                    }
                    else if (value instanceof Object) {
                        for (subName in value) {
                            subValue = value[subName];
                            fullSubName = name + '[' + subName + ']';
                            innerObj = {};
                            innerObj[fullSubName] = subValue;
                            query += param(innerObj) + '&';
                        }
                    }
                    else if (value !== undefined && value !== null) {
                        query += encodeURIComponent(name) + '=' + encodeURIComponent(value) + '&';
                    }
                }

                return query.length ? query.substr(0, query.length - 1) : query;
            };

            return angular.isObject(data) && String(data) !== '[object File]' ? param(data) : data;
        }];


        $urlRouterProvider
            .otherwise('');

        $stateProvider
            .state("home", {
                url: "",

                template: ''
            })

            .state('about', {
                url: '',

                templateUrl: '/test.html',


                controller: ['$scope', '$state',
                    function ($scope, $state) {

                    }]
            });
    }).

    filter('orderObjectBy', function () {
        return function (items, field, reverse) {
            var filtered = [];
            angular.forEach(items, function (item) {
                filtered.push(item);
            });
            filtered.sort(function (a, b) {
                return (a[field] > b[field] ? 1 : -1);
            });
            if (reverse) filtered.reverse();
            return filtered;
        };
    })


    .directive('videojs', function () {
        var linker = function (scope, element, attrs) {
            attrs.type = attrs.type || "video/mp4";

            var setup = {
                'techOrder': ['html5', 'flash'],
                'controls': true,
                'preload': 'auto',
                'autoplay': false,
                'height': 264,
                'width': 470
            };

            var video_name = scope.$eval(attrs.fileName);

            attrs.id = "videojs" + video_name;
            element.attr('id', attrs.id);
            element.attr('poster', "http://maareke-video.s3.amazonaws.com/thumbs/" + video_name + ".png");
            var player = _V_(attrs.id, setup, function () {
                var source = ([
                    {type: "video/mp4", src: "http://maareke-video.s3.amazonaws.com/" + video_name + ".mp4"}
                ]);
                this.src({type: attrs.type, src: source });
            });
        };

        return {
            restrict: 'A',
            link: linker
        };
    })


    .factory('Reddit', function ($http) {
        var Reddit = function (param) {
            this.items = {};
            this.busy = false;
            this.after = 0;
            this.param = param;
        };

        Reddit.prototype.nextPage = function () {
            if (this.busy) return;
            this.busy = true;

            var url = "/get_last_posts/?start=" + this.after;
            if (this.param != 0) {
                url += '&user=' + this.param;
            }

            $http.get(url).success(function (data) {
                var items = data.data;
                for (var i = 0; i < items.length; i++) {
                    var key = 'post_' + items[i]['id'].toString();
                    this.items[key] = items[i];
                }

                this.after = data.last_id;
                this.busy = false;
            }.bind(this));
        };

        return Reddit;
    })

    .controller('ScrollCtrl', function ($scope, Reddit, $http, $location) {
        var path = $location.absUrl().split('/')[3] || 'unknown';
        var param = $location.absUrl().split('/')[4] || 'unknown';

        var post_param = 0;
        if ((path == 'user') && (!isNaN(parseInt(param)))) {
            post_param = param;
        }

        $scope.reddit = new Reddit(post_param);

        $scope.getComments = function (timeline_id) {
            var key = 'post_' + timeline_id.toString();
            return $scope.reddit.items[key].comments;
        };

        $scope.addComment = function (event, item) {
            if (event.keyCode == 13 && !event.shiftKey) {
                event.preventDefault();

                comment_data = {'text': item.comment, 'object_type': item.object_type, 'object_id': item.object_id};
                var comment_text = item.comment;

                $http({url: '/add_comment/', data: comment_data, method: "POST"}).success(function (data) {
                    if (data.success) {
                        var comment = {
                            'comment_id': data.comment_id,
                            'text': comment_text,
                            'datetime': data.datetime,
                            'applause': data.applause,
                            'show_delete': data.show_delete,
                            'author': data.author,
                            'author_id': data.author_id,
                            'author_avatar': data.author_avatar
                        };
                        var key = 'post_' + item.id.toString();
                        $scope.reddit.items[key].comments.push(comment);
                    } else {
                        showErrorToast(data.message);
                    }
                }).error(function (data, status, headers, config) {
                    showErrorToast('Error when connecting to server!')
                });

                item.comment = '';
            }
        };

        $scope.deleteComment = function (comment, item) {
            comment_data = {'object_type': item.object_type, 'object_id': item.object_id, 'comment_id': comment.comment_id};

            $http({url: '/delete_comment/', data: comment_data, method: "POST"}).success(function (data) {
                if (data.success) {
                    var key = 'post_' + item.id.toString();
                    var index = $scope.reddit.items[key].comments.indexOf(comment);
                    $scope.reddit.items[key].comments.splice(index, 1);
                } else {
                    showErrorToast(data.message);
                }
            }).error(function (data, status, headers, config) {
                showErrorToast('Error when connecting to server!')
            });
        };


        $scope.hover = function (comment) {
            // Shows/hides the delete button on hover
            if (comment.show_delete) {
                return comment.showDelete = !comment.showDelete;
            } else {
                return comment.showDelete = false;
            }
        };

        $scope.applause = function (from_user, item) {
            var applause_data = {
                'from_user': from_user,
                'to_user': item.author_id,
                'object_type': item.object_type,
                'object_id': item.object_id
            };

            $http({url: '/applause/', data: applause_data, method: "POST"}).success(function (data) {
                if (data.status) {
                    $('#applauseAudio')[0].play();

                    var key = 'post_' + item.id.toString();
                    $scope.reddit.items[key].applause += 1;
                } else {
                    showErrorToast(data.message);
                }
            }).error(function (data, status, headers, config) {
                showErrorToast('Error when connecting to server!')
            });


        };

    })

    .controller('SearchCtrl', function ($scope, $http) {
        $scope.searchText = null;
        $scope.change = function (text) {
            valtosend = $scope.searchText;
            if (valtosend.length != 0) {
                $http.get('/search_data/' + valtosend).then(function (result) {
                    $scope.entries = result.data;
                });
            }
        };
    })

    .controller('PageTypeSelectCtrl', function ($scope, $state) {
        $scope.update = function () {
//            alert($scope.selectedItem);
            $state.go('about', {'test': 1});
        }
    })

    .run([
        '$http',
        '$cookies',
        function ($http, $cookies) {
            $http.defaults.headers.post['X-CSRFToken'] = $cookies.csrftoken;
        }]);

