require 'watir'

directory, path_to_list = ARGV[0..1]

require_relative 'prepare_directory'
prepare_directory directory

browser = Watir::Browser.new

require_relative 'post'
links = IO.read(path_to_list).split "\n"
links.size.downto(1).zip(links).each do |number, link|
  post = Post.new browser: browser, link: link
  post.save_to "#{directory}/#{number}"
end
