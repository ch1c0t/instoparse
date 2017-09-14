require 'fileutils'

def prepare_directory directory
  if Dir.exist? directory
    fail "#{directory} already exists. We won't risk overriding its content."
  end

  FileUtils.mkdir_p directory
end
