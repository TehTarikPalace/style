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
  var cat_data = [];
  var entity_data = [];

  //assumption data is sorted by ENTITY_CAT
  $.each( this.params['stats'], function(index, value){

    //look for same category data
    //if the cat is there, push data, else nothing
    var inCat = false;

    //build cat data
    $.each( cat_data, function(i,v){
        if(v.id == value.ENTITY_CAT){
          //find the correnspending entity data
          $.each( entity_data, function(entity_i, entity_v){
            if(entity_v.name == value.ENTITY_CAT){
                entity_v.y += parseInt(value.ENTITY_COUNT);
                return false;
            }
          });
          //v.y += parseInt(value.ENTITY_COUNT);
          //v.data.push ( [value.ENTITY, parseInt(value.ENTITY_COUNT)] );
          v.data.push( { name: value.ENTITY, y: parseInt(value.ENTITY_COUNT)});
          inCat = true;
          return false;
        };
    });

    if(inCat == false){
      cat_data.push({
        id: value.ENTITY_CAT,
        data: [{ name:value.ENTITY, y: parseInt(value.ENTITY_COUNT)}]
        //y: parseInt(value.ENTITY_COUNT)
      });

      entity_data.push({
          name: value.ENTITY_CAT,
          y: parseInt(value.ENTITY_COUNT),
          drilldown: value.ENTITY_CAT
      });
    }

    //data_array.push( { name:value.ENTITY, y: parseInt(value.ENTITY_COUNT) });

  });


  console.log(cat_data);
  console.log(entity_data);

  $('#repo-stats-chart').highcharts({
    chart: { type:'pie'},
    title: { text: this.params['repo_name'] + ' Composition'},
    xAxis:{
      type: 'category'
    },
    legend: { enabled:false },
    drilldown: {
      allowPointDrilldown: true,
      series: cat_data
    },
    series: [{
        name: 'Data Type Count',
        colorByPoint: true,
        data: entity_data
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

StudioConnectionsController.prototype.conformity = function(){
  //load the actual report
  $.get(window.location.pathname + ".template", null, function(data){
    $('#conformity-report').empty().append(data);
  });
};

StudioConnectionsController.prototype.users = function(){
  $('.collapse').on('shown.bs.collapse', function(){
    if($(this).children().length == 0 ){
      var table_row_handle = $(this);
      $.get( $(this).attr('data-load'), null, function(data){
        table_row_handle.append(data);
      }, 'html');
    }
  });
};

StudioConnectionsController.prototype.dashboard = function(){
  $('.request-result').click(function(){
    var handle = $(this);
    $(this).find('i').toggleClass('fa-spin');
    $.get(handle.attr('data-querypath'), null, function(data){
      $(handle.attr('data-target')).empty().append(data);
      $(handle).find('i').toggleClass('fa-spin');
    });
  });
};
