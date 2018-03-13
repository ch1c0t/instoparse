require 'watir'

username = ARGV[0]

b = Watir::Browser.new
b.goto "https://instagram.com/#{username}"

article = b.article
article.attribute :class #=> "_mesn5"
article.children.size #=> 2

header = article.header
header.attribute :class #=> "_mainc"

div = article.children[1]
div.children.size #=> 3 with load more; or 2 -- without


require 'pp'

images = div.divs class: %w[_mck9w _gvoze _tn0ps]
pp images.map { |image| image.a.href }

b.send_keys :end
sleep 1

loop do
  b.send_keys :end
  images = b.images
  pp images.map { |image| image.a.href }

  sleep 3
end
