def google_analytics(token)
  <<-EOS
  <script>
      var _gaq = [['_setAccount', '#{token}'], ['_trackPageview']];
      (function(d, t) {
          var g = d.createElement(t),
              s = d.getElementsByTagName(t)[0];
          g.async = true;
          g.src = '//www.google-analytics.com/ga.js';
          s.parentNode.insertBefore(g, s);
      })(document, 'script');
  </script>
  EOS
end

