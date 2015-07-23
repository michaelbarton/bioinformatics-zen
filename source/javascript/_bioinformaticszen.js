$(document).delegate('*[data-toggle="lightbox"]', 'click', function(event) {

  // Lightbox
  event.preventDefault();
  $(this).ekkoLightbox();

  // Code highlighting
  $('pre code').each(function(i, block) {
    hljs.highlightBlock(block);
  });

});

