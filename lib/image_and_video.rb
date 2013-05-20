def image(url,alt,width=400,options={})
  "<div class='centred'>
    <a href='#{urlify(url)}'>
      <img src='#{urlify(url)}' width='#{width}' alt='#{alt}' />
    </a>
  </div>"
end

def youtube(video,title="YouTube")
  "<a href='http://www.youtube.com/watch?v=#{video}&amp;hd=1' id='lightbox_youtube' title='#{title}'><img src='http://img.youtube.com/vi/#{video}/0.jpg' alt='#{title}'/></a>"
end

def lightbox(image, thumbnail, alt, width=320)
  "<div class='centred'>
      <a id='lightbox_image' href='#{urlify(image)}'>
        <img src='#{urlify(thumbnail)}' width='#{width}' alt='#{alt}' />
      </a>
  </div>"
end

def poster(name,description)
  base = 'http://uk-me-michaelbarton.s3.amazonaws.com/posters/' + name
  lightbox(base + '/michael_barton_poster.png',
           base + '/thumb.png',
           description,
           width=320)
end
