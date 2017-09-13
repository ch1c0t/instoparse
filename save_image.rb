require 'open-uri'

IO.write '/tmp/image.jpg', open(browser.image.src).read
