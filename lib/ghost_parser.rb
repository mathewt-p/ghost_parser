# frozen_string_literal: true

require_relative "ghost_parser/json_parser"

class GhostParser
  attr_reader :file_path

  def initialize(file_path)
    @file_path = file_path
  end

  def parse(attributes = nil, options = {}, &block)
    raise "File not found" if !File.exist?(file_path)
    file = File.read(file_path)
    json_array = JsonParser.new(file).call
    result_array = []
    json_array.each do |json|
      result = {}
      config.each do |k, v|
        result[k] = json[v]
      end
      result.merge!(attributes) if !attributes.nil?
      yield(result) if block_given?
      result_array << result
    end
    return result_array
  end

  def config
    @@config ||= self.default_config
  end

  def self.set_config(params = nil)
    @@config = params || default_config
  end

  private

  def default_config
    {
      id: "id",
      title: "title",
      slug: "slug",
      html: "html",
      status: "status",
      feature_image: "feature_image",
      created_at: "created_at",
      updated_at: "updated_at",
      published_at: "published_at"
    }
  end
end
