module LegacyHelpers

  def image(url,alt,width=400,options={})
    "<div class='centred'>
      <a href='#{url}'>
        <img src='#{url}' width='#{width}' alt='#{alt}' />
      </a>
    </div>"
  end

  def lightbox(image, thumbnail, alt, width=320)
    "<div class='centred'>
        <a id='lightbox_image' href='#{image}'>
          <img src='#{thumbnail}' width='#{width}' alt='#{alt}' />
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

end
