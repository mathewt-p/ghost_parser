# frozen_string_literal: true

require_relative "ghost_parser/json_parser"

class GhostParser
  attr_reader :file_path

  def initialize(file_path)
    @file_path = file_path
  end

  def parse(options = {}, &block)
    raise "File not found" if !File.exist?(file_path)
    file = File.read(file_path)
    json_array = JsonParser.new(file).call
    result_array = []
    json_array.each do |json|
      result = {}
      config.each do |k, v|
        result[k] = json[v]
      end
      result.merge!(options) if !options.empty?
      yield(result) if block_given?
      result_array << result
    end
    return result_array
  end

  def config
    @@config ||= default_config
  end

  class << self

    def set_config(params = nil)
      @@config = params || default_config
    end

    def default_config
      {
        id: "id",
        title: "title",
        slug: "slug",
        html: "html",
        feature_image: "feature_image",
        created_at: "created_at",
        updated_at: "updated_at",
        published_at: "published_at"
      }
    end
  end
end
