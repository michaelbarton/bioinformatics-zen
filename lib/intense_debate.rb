def comments(item)
  <<-EOS
  <script type='text/javascript'>
    var idcomments_acct     = '2fcd532c05e4f66ac57f8adfafbc9c11';
    var idcomments_post_id  = 'www.bioinformaticszen.com#{item.path}';
    var idcomments_post_url = '#{item.path}';
  </script>
  <span id='IDCommentsPostTitle' style='display:none'></span>
  <script src='http://www.intensedebate.com/js/genericCommentWrapperV2.js' type='text/javascript'></script>
  EOS
end
