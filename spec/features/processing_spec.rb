# frozen_string_literal: true

RSpec.feature "processing", type: :feature, js: true do
  around do |example|
    Sidekiq::Testing.inline! do
      example.call
    end
  end

  let(:rubygems_data) do
    {
      name: "some_gem",
      source_code_uri: "https://github.com/some/some_gem",
      info: "Just a sample gem",
      downloads: 1_526_321,
      version: "2.0.0",
      licenses: ["MIT"]
    }
  end

  let(:github_data) do
    {
      full_name: "some/some_gem",
      stargazers_count: 1_234,
      pushed_at: "2023-01-26T19:06:43Z"
    }
  end

  let(:issues) do
    [
      {
        id: 1234,
        title: "Sample issue",
        html_url: "https://github.com/some/some_gem/issues/1",
        comments: 5,
        created_at: "2023-01-26T19:06:43Z",
        labels: [{name: "help wanted", color: "333333"}]
      },
      {
        id: 1235,
        title: "Another issue",
        html_url: "https://github.com/some/some_gem/issues/2",
        comments: 10,
        created_at: "2023-01-26T19:06:43Z",
        labels: [{name: "help wanted", color: "333333"}]
      }
    ]
  end

  before do
    stub_request(:get, "https://rubygems.org/api/v1/search.json?page=1&query=downloads:%3E1000000")
      .to_return(status: 200, body: [rubygems_data].to_json)
    stub_request(:get, "https://rubygems.org/api/v1/search.json?page=2&query=downloads:%3E1000000")
      .to_return(status: 200, body: [].to_json)
    stub_request(:get, "https://rubygems.org/api/v1/gems/some_gem.json")
      .to_return(status: 200, body: rubygems_data.to_json)
    stub_request(:get, "https://api.github.com/repos/some/some_gem")
      .to_return(status: 200, body: github_data.to_json, headers: {"Content-Type" => "application/json; charset=utf-8"})
    stub_request(:get, "https://api.github.com/repos/some/some_gem/issues?labels=help%20wanted&per_page=100&state=open")
      .to_return(status: 200, body: issues.to_json, headers: {"Content-Type" => "application/json; charset=utf-8"})
  end

  scenario "discover and sync data" do
    ::Processing::Workers::DiscoverWorker.perform_async

    visit "/"
    within ".intro" do
      click_link "Browse gems"
    end

    expect(page).to have_content("some_gem")
    expect(page).to have_content("Just a sample gem")

    click_link "some_gem"

    expect(page).to have_content("some_gem")
    expect(page).to have_content("Just a sample gem")
    expect(page).to have_content("Sample issue")
    expect(page).to have_content("Another issue")
    expect(page).to have_content("RubyGems Downloads 1,526,321", normalize_ws: true)
    expect(page).to have_content("GitHub Stars 1,234", normalize_ws: true)
    expect(page).to have_content("GitHub Repository some/some_gem", normalize_ws: true)
  end
end
