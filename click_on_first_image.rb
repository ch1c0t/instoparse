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
div.children.size #=> 3

div.children[1].attribute :class #=> "_gwyj6"
# div at the bottom; contains strange shit with iframe

div.children[2].attribute :class #=> "_1cr2e _epyes"
div.children[2].class #=> Watir::Anchor < Watir::HTMLElement
# "Load more" button at the bottom

image_table = div.children[0]
image_table.attribute :class #=> "_cmdpi"
# A table with images. 4 rows; 3 images in each of them.
image_table.children.size #=> 4(rows)

first_row = image_table.children.first
first_row.attribute :class #=> "_70iju"(each row has this attribute)

# Click on the first image.
first_row.children.first.click
sleep 3
