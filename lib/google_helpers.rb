module GoogleHelpers
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

  def google_webmaster_verification
    '<meta name="google-site-verification" content="3rmUqoTcd9sbLDSIn6V8l_9D1NDCYViQTarIb9MunsM" />'
  end

  def google_fonts
    return unless data.config[:google_fonts]
    output = String.new
    data.config[:google_fonts].each do |font_name,fonts|
      family = font_name.to_s + ':' + fonts * ','
      link = "http://fonts.googleapis.com/css?family=#{family}&amp;subset=latin"
      output << "<link href='#{link}' media='all' type='application/x-font-woff'>\n"
    end
    output
  end
end
