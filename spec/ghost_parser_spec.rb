# frozen_string_literal: true

RSpec.describe GhostParser do
  it "has a version number" do
    expect(GhostParser::VERSION).not_to be nil
  end

  it "Parses Json" do
    file_path = "/home/mathew/Downloads/the-engineering-org.ghost.2023-01-13-19-42-35.json"
    parsed_file = GhostParser.read_file(file_path)
    expect(parsed_file[0].keys).to eq([:id, :title, :slug, :html, :feature_image, :created_at, :updated_at, :published_at])
  end
end
