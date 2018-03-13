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

if div.children.size == 3
  load_more_button = div.children[2]
  load_more_button.attribute :class #=> "_1cr2e _epyes"
  load_more_button.class #=> Watir::Anchor < Watir::HTMLElement
end
# "Load more" button at the bottom

posts_count, _followers, _following = b.spans(class: '_fd86t').map do |span|
  span.text
end
posts_count = posts_count.to_i
puts "#{username} has #{posts_count} public posts." if ENV['DEBUG']


images = div.divs class: %w[_mck9w _gvoze _tn0ps]
images.size

b.send_keys :end
sleep 1
load_more_button&.click

puts "Count of currently shown images: #{images.count}." if ENV['DEBUG']
until images.count == posts_count
  b.send_keys :end
  images = div.divs(class: %w[_mck9w _gvoze _f2mse])
  sleep 1
end

links = images.map { |image| image.a.href }
puts "Links count(#{links.count}) should be equal to posts_count(#{posts_count})." if ENV['DEBUG']
puts links.join "\n"
