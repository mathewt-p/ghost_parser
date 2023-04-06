# frozen_string_literal: true

require_relative "ghost_parser/json_parser"
require "nokogiri"

class GhostParser
  attr_reader :file_path
  @@ghost_url = ""

  Default_Config = {
    id: "id",
    title: "title",
    slug: "slug",
    html: "html",
    feature_image: "feature_image",
    created_at: "created_at",
    updated_at: "updated_at",
    published_at: "published_at",
    status: "status"
  }

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
    return format_result(result_array)
  end

  def config
    @@config ||= Default_Config
  end

  def self.set_config(params = nil)
    @@config = params
  end

  def self.set_ghost_url(url)
    @@ghost_url = url
  end

  def self.unset_config
    @@config = Default_Config
  end

  private

  def format_result(result_array)
    if (@@ghost_url.nil? || @@ghost_url.empty?)
      Warning.warn "Ghost url has not been initialized, urls in the export will not be valid"
    else
      result_array.each do |result|
        result[config.key("html")] = format_html_content(result[config.key("html")]) if config.key("html")
        result[config.key("feature_image")] = format_feature_image(result[config.key("feature_image")]) if config.key("feature_image")
      end
    end
    result_array
  end

  def format_html_content(content) 
    doc = Nokogiri::HTML.fragment(content)
    doc.css("a[href]").each do |link| 
      link['href'] = replace_url(link['href'])
    end
    doc.css("img[src]").each do |img| 
      img['src'] = replace_url(img['src'])
    end
    return doc.to_html
  end

  def format_feature_image(image)
    replace_url(image)
  end

  def replace_url(url)
    return url&.gsub("__GHOST_URL__", @@ghost_url)
  end
end
