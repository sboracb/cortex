angular.module('cortex.resources', [
  'ngResource',
  'cortex.settings',
  'cortex.session'
])

.constant('defaultActions', {
  'get':    {method: 'GET'},
  'save':   {method: 'POST'},
  'query':  {method: 'GET', isArray: true},
  'remove': {method: 'DELETE'},
  'delete': {method: 'DELETE'}
})

.constant('updateCreateActions', {
  update: {method: 'PUT', inArray: false},
  create: {method: 'POST'}
})

.factory('cortexResource', function($resource, settings, currentUser, updateCreateActions) {
  return function (url, params, actions) {
    actions = angular.extend(updateCreateActions, actions);

    var resource = $resource(settings.cortex_base_url + url, params, actions);

    resource.prototype.$save = function(params, success, error) {
        return this.id ? this.$update(params, success, error) : this.$create(params, success, error);
    };
    return resource;
  };
})

.factory('paginatedResource', function(cortexResource, defaultActions) {
  var forEach    = angular.forEach,
    extend     = angular.extend,
    isFunction = angular.isFunction;

  return function(url, params, actions) {
    actions = extend(actions, defaultActions);

    var resource = cortexResource(url, params, actions);

    forEach(actions, function(action, name) {
      // If action is paginated ($query() or pagination == true in action config)

      if (/^(QUERY)$/i.test(name) || action.paginated) {

        // Wrap action function in pagination handler
        resource[name + 'Paged'] = function(params, success, error) {
          if (isFunction(params)) {
            error = success; success = params; params = {};
          }

          var wrappedSuccess = function(data, headers) {
            var pagination;
            var range = headers('Content-Range');
            if (range) {
              // Parse pagination information from Content-Range header (Format: start-end:per_page/count)
              range = range.match(/(\d+)-(\d+):(\d+)\/(\d+)$/);

              if (range.length != 5) {
                throw new RangeError('Content-Range header contained ill-formated pagination data.');
              }

              var start    = range[1];
              var end      = range[2];
              var per_page = range[3];
              var count    = range[4];
              var page     = params.page || 1;

              pagination = {
                page: page,
                pages: parseInt(count / per_page) + 1,
                start: start,
                end: end,
                per_page: per_page,
                count: count
              };
            }

            // Call original callback
            if (isFunction(success)) {
              success(data, headers, pagination);
            }

          };

          return resource[name](params, wrappedSuccess, error);
        };
      }
    });

    return resource;
  };
})
