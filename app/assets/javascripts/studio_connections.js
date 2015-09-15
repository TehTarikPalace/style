var StudioConnectionsController = Paloma.controller("StudioConnections");

StudioConnectionsController.prototype.show = function(){
    console.log("start loading the repo");

    var conn_id = $("#repository-list").attr("data-repo-id");

    //get the repo list
    $.get("/studio_connections/" + conn_id + "/repositories.template", null, function(data){

      $('#loading-repo').hide();
      $('#repository-list').find('tbody').append(data);
    });
};

StudioConnectionsController.prototype.show_repo = function(){
  //load contents of repo
  console.log("looking for " + this.params['repository']);
  console.log("grabbing" + this.params['content_path']);
  $.get(this.params['content_path'], null, function(data){
      $('#repo-content').empty().append(data);
  });
};

StudioConnectionsController.prototype.browse_repo = function(){
  
  $.get(this.params['content_path'], null, function(data){
      $('#repo-content').empty().append(data);
  });
}
