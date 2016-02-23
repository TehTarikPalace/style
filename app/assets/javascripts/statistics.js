var StatisticsController = Paloma.controller("Statistics");

StatisticsController.prototype.edit_categories = function(){
  $('#new-category').click( function(){
    $.get('/statistics/new_category', null, function(data){
      $('#new-category-tr').before(data).ready(function(){
          $('#category-list').find('.delete-category').each( function(index){
              var handle = $(this);
              handle.click(function(){
                  handle.closest('.category-row').remove();
              })
          });
      });
    });
  });
};

StatisticsController.prototype.edit_headers = function(){
  $('#new-header').click( function(){
    $.get('/statistics/new_header', null, function(data){
      $('#new-header-tr').before(data).ready(function(){
        $('#header-list').find('.delete-category').each( function(index){
            var handle = $(this);
            handle.click(function(){
                handle.closest('.header-row').remove();
            })
        }); // $('#category-list')...
      })
    });

  });
};
