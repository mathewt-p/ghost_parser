# frozen_string_literal: true

RSpec.describe GhostParser do

  it "Parses Json" do
    file_path = "#{__dir__}/fixtures/sample_ghost_export.json"
    parsed_file = GhostParser.new(file_path).parse
    expect(parsed_file[0].keys).to eq([:id, :title, :slug, :html, :feature_image, :created_at, :updated_at, :published_at, :status])
  end

  it "Sets custom json" do
    GhostParser.set_config({
      new_id: "id",
      name: "title",
      new_slug: "slug"
    })
    file_path = "#{__dir__}/fixtures/sample_ghost_export.json"
    parsed_file = GhostParser.new(file_path).parse
    expect(parsed_file[0].keys).to eq([:new_id, :name, :new_slug])
  end

  it "uses block" do
    file_path = "#{__dir__}/fixtures/sample_ghost_export.json"
    parsed_file = GhostParser.new(file_path).parse do |tt|
                  tt[:random_key] = "test"
                end
    expect(parsed_file[0][:random_key]).to eq("test")        
  end

  it "Passes parameter" do
    file_path = "#{__dir__}/fixtures/sample_ghost_export.json"
    parsed_file = GhostParser.new(file_path).parse(
                    {param_key: "123"}
                  )
    expect(parsed_file[0][:param_key]).to eq("123")        
  end

  it "Parses Json and formats urls" do
    file_path = "#{__dir__}/fixtures/sample_ghost_export.json"
    ghost_url = "https://example.com"
    GhostParser.unset_config
    GhostParser.set_ghost_url ghost_url
    parsed_file = GhostParser.new(file_path).parse
    expect(parsed_file.last[:feature_image].include?(ghost_url)).to eq(true)
  end

  it "Parses Json and formats urls" do
    file_path = "#{__dir__}/fixtures/sample_ghost_export.json"
    ghost_url = "https://example.com"
    GhostParser.set_config(
      {
        title: "title",
        slug: "slug",
        content: "html",
        feature_image: "feature_image",
        created_at: "created_at",
        updated_at: "updated_at",
        published_at: "published_at",
        status: "status"
      }
    )
    GhostParser.set_ghost_url ghost_url
    parsed_file = GhostParser.new(file_path).parse
    expect(parsed_file.last[:feature_image].include?(ghost_url)).to eq(true)
    expect(parsed_file.last[:content].empty?).to eq(false)
  end
end
