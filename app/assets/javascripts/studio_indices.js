var StudioIndicesController = Paloma.controller("StudioIndices");

StudioIndicesController.prototype.show = function(){
    var env_dump_path = this.params['env_dump_path'];

    $('.collapse').on('show.bs.collapse', function(){
      console.log('should load ' + env_dump_path);
      handle = $(this);
      if(handle.children().length == 0){
        console.log('should load data');
      }
      $.get(env_dump_path, { nav_path:handle.attr('data-env')}, function(data){
          handle.empty().append(data);
      }).fail( function(){
          handle.empty().append("Error loading the Data Environment File");
      });
    })
};
