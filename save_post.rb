require 'watir'

directory, link = ARGV[0..1]
browser = Watir::Browser.new

require_relative 'post'
post = Post.new browser: browser, link: link
post.save_to directory
