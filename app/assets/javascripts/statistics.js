var StatisticsController = Paloma.controller("Statistics");

StatisticsController.prototype.edit_categories = function(){
  $('#new-category').click( function(){
    $.get('/statistics/new_category', null, function(data){
      $('#category-list').prepend(data).ready(function(){
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
