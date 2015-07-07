$(document).ready(function() {


$('.followers-label').on('click',function() {
    $(".followers-label").css('color','black');
   $(".following-label").css('color','#ccc');
   $(".followings-list").hide(0);
   $(".followers-list").show(0)
});


$('.followers_tab').on('click',function() {
    $(".followers-label").css('color','black');
   $(".following-label").css('color','#ccc');
   $(".followings-list").hide(0);
   $(".followers-list").show(0)
});

$('.following-label').on('click',function() {
    $(".following-label").css('color','black');
   $(".followings-list").show(0);
    $(".followers-label").css('color', '#ccc');
     $(".followers-list").hide(0);
});

$('.following_tab').on('click',function() {
    $(".following-label").css('color','black');
   $(".followings-list").show(0);
    $(".followers-label").css('color', '#ccc');
     $(".followers-list").hide(0);
});


var tag_line = $('.tag-line');
tag_line.on('blur', function(){
new_tag_line = tag_line.html()
  $.ajax(
    {
      url: "/save_tag",
      type: "post",
      data: {new_tag: new_tag_line},
      success: function(result){
        console.log (result);          
      },
      error: function(result){
        console.log (result);
      },
    }
  );
})

});
