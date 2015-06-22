$(document).ready(function(){
  $("a#lightbox_image").fancybox();

  $("a#lightbox_youtube").click(function() {
    $.fancybox({
      'padding'       : 0,
      'autoScale'     : false,
      'transitionIn'  : 'none',
      'transitionOut' : 'none',
      'title'         : this.title,
      'width'         : 680,
      'height'        : 495,
      'href'          : this.href.replace(new RegExp("watch\\?v=", "i"), 'v/'),
      'type'          : 'swf',
      'swf'           : {
        'wmode'           : 'transparent',
      'allowfullscreen' : 'true'
      }
    });

    return false;
  });

});
