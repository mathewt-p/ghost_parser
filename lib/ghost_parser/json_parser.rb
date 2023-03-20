require 'json'

class JsonParser
  attr_reader :file_content

  def initialize(file_content)
    @file_content = file_content
  end

  def call
    JSON.load(file_content)["db"][0]["data"]["posts"]
  end
end
