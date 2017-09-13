require 'open-uri'
require 'yaml'
require 'watir'
require 'nokogiri'

directory, link = ARGV[0..1]

if Dir.exist? directory
  fail "#{directory} already exists. We won't risk overriding its content."
end

require 'fileutils'
FileUtils.mkdir_p directory

b = Watir::Browser.new
b.goto link


IO.write "#{directory}/date", b.time.datetime


comments = b.lis class: '_ezgzd'
if comments.size > 0
  comments = comments.map do |comment|
    {
      author: comment.a.title,
      string: comment.span.text,
    }
  end

  IO.write "#{directory}/comments.yml", comments.to_yaml
end


image = b.div(class: '_4rbun').image.src
begin
  IO.write "#{directory}/image.jpg", open(image).read
rescue
  puts "Failed to save the image at #{link}. See the reason below."
  puts $!
end


location_tag = b.a(class: %w[_q8ysx _6y8ij])
if location_tag.exist?
  doc = Nokogiri::HTML open(location_tag.href).read
  location = {
    latitude: doc.at('meta[property="place:location:latitude"]')['content'],
    longitute: doc.at('meta[property="place:location:longitude"]')['content'],
  }

  IO.write "#{directory}/location.yml", location.to_yaml
end
