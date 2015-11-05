var SettingsController = Paloma.controller("Settings");

SettingsController.prototype.admins = function(){
  console.log('loaded settings/admin');

  var delete_admin = function(target){
    $(target).closest('.form-group').remove();
  };

  $('.delete-admin').click( function(){
      delete_admin($(this));
  } );

  $('#new-admin').click(function(){
      $.get('/users/new.template', function(data){
          $('#admin-list').append(data).ready(function(){
            var handle = $(this);
            handle.find('.delete-admin').click(function(){
              delete_admin($(this));
            });
          });
      });
  });
};
