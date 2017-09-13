require 'open-uri'
require 'yaml'
require 'watir'
require 'nokogiri'

directory, path_to_list = ARGV[0..1]

if Dir.exist? directory
  fail "#{directory} already exists. We won't risk overriding its content."
end

require 'fileutils'
FileUtils.mkdir_p directory

browser = Watir::Browser.new

require_relative 'post'
links = IO.read(path_to_list).split "\n"
links.size.downto(1).zip(links).each do |number, link|
  post = Post.new browser: browser, link: link
  post.save_to "#{directory}/#{number}"
end
