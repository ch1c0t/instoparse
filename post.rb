require 'fileutils'
require 'open-uri'
require 'yaml'
require 'nokogiri'

class Post
  def initialize browser:, link:
    @browser, @link = browser, link
  end

  def save_to directory
    prepare_directory directory
    @browser.goto @link

    save_date_to directory
    save_comments_to directory
    save_image_to directory
    save_location_to directory
  end

  private
    def prepare_directory directory
      if Dir.exist? directory
        fail "#{directory} already exists. We won't risk overriding its content."
      end

      FileUtils.mkdir_p directory
    end

    def save_date_to directory
      IO.write "#{directory}/date", @browser.time.datetime
    end

    def save_comments_to directory
      comments = @browser.lis class: '_ezgzd'
      if comments.size > 0
        comments = comments.map do |comment|
          {
            author: comment.a.title,
            string: comment.span.text,
          }
        end

        IO.write "#{directory}/comments.yml", comments.to_yaml
      end
    end

    def save_image_to directory
      image = @browser.div(class: '_4rbun').image.src
      IO.write "#{directory}/image.jpg", open(image).read
    rescue
      puts "Failed to save the image at #{@link}. See the reason below."
      puts $!
    end

    def save_location_to directory
      location_tag = @browser.a(class: %w[_q8ysx _6y8ij])
      if location_tag.exist?
        doc = Nokogiri::HTML open(location_tag.href).read
        location = {
          latitude: doc.at('meta[property="place:location:latitude"]')['content'],
          longitute: doc.at('meta[property="place:location:longitude"]')['content'],
        }

        IO.write "#{directory}/location.yml", location.to_yaml
      end
    end
end
