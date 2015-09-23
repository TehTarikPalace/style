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
  $.get(this.params['content_path'], null, function(data){
      $('#repo-content').empty().append(data);
  });
};

StudioConnectionsController.prototype.browse_repo = function(){

  $.get(this.params['content_path'], null, function(data){
      $('#repo-content').empty().append(data);
  });

  $.get(this.params['history_path'], null, function(data){
    $('#history-content').empty().append(data);
  });

  $.get(this.params['object_dump_path'], null, function(data){
    $('#object-info').empty().append(data);
  });

};

StudioConnectionsController.prototype.repo_stats = function(){
  console.log("stats: " + this.params['stats'][0].ENTITY);
  var data_array = [];
  $.each( this.params['stats'], function(index, value){
      data_array.push( { name:value.ENTITY, y: parseInt(value.ENTITY_COUNT) });
  } );

  $('#repo-stats-chart').highcharts({
    chart: { type:'pie'},
    title: { text: this.params['repo_name'] + ' Composition'},
    series: [{
        colorByPoint: true,
        data: data_array
    }]
  });
};

StudioConnectionsController.prototype.repo_object_stats = function(){
  var data_array = [];
  $.each( this.params['stats'], function(index, value){
      data_array.push( [ Date.parse(value.INSERT_DATE), parseInt(value.INSERT_COUNT)] );
  });

  Highcharts.setOptions({
      global: { useUTC:false}
  });

  $('#object-stats-chart').highcharts({
      chart: { type: 'scatter'},
      title: { text: 'Insert Activity'},
      xAxis: { type: 'datetime'},
      series:[{
          type: 'scatter',
          name: 'insert activity',
          tooltip: {
              pointFormatter: function(){
                return '<b>' + Highcharts.dateFormat('%e-%b-%Y %H:%M:%S', this.x) + '</b><br>' + this.y
              }
          },
          data: data_array
      }]
  });
};
