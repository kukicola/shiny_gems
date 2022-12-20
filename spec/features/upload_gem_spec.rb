# frozen_string_literal: true

RSpec.feature "upload gem", type: :feature, js: true do
  let(:repos) do
    [
      {
        id: 1296269,
        name: "ExampleRepo",
        full_name: "test/example-repo",
        stargazers_count: 99
      }
    ]
  end
  let(:repo_content) do
    [
      {
        name: "example-gem.gemspec"
      }
    ]
  end
  let(:gemspec) do
    {
      content: Base64.encode64(File.read("#{SPEC_ROOT}/support/files/example-gem.gemspec"))
    }
  end
  let(:gem_info) do
    {
      name: "example-gem",
      info: "example-gem is great gem!",
      homepage_uri: "https://github.com/test/example-repo",
      downloads: 100
    }
  end
  let(:issues) do
    [
      {
        id: 1235325,
        title: "Some weird error",
        html_url: "https://github.com/test/example-repo/issues/2",
        comments: 5,
        labels: [
          {
            name: "bug",
            color: "f5f5f5"
          }
        ]
      }
    ]
  end

  before do
    stub_request(:get, "https://api.github.com/user/repos?per_page=100&sort=asc")
      .with(headers: {"Authorization" => "token abc"})
      .to_return(status: 200, body: repos.to_json, headers: {"Content-Type" => "application/json; charset=utf-8"})

    stub_request(:get, "https://api.github.com/repos/test/example-repo/contents/")
      .with(headers: {"Authorization" => "Basic eHh4Onh4eA=="})
      .to_return(status: 200, body: repo_content.to_json, headers: {"Content-Type" => "application/json; charset=utf-8"})

    stub_request(:get, "https://api.github.com/repos/test/example-repo/contents/example-gem.gemspec")
      .with(headers: {"Authorization" => "Basic eHh4Onh4eA=="})
      .to_return(status: 200, body: gemspec.to_json, headers: {"Content-Type" => "application/json; charset=utf-8"})

    stub_request(:get, "https://rubygems.org/api/v1/gems/example-gem.json")
      .to_return(status: 200, body: gem_info.to_json)

    stub_request(:get, "https://api.github.com/repos/test/example-repo/issues?per_page=100&sort=created&state=open")
      .with(headers: {"Authorization" => "Basic eHh4Onh4eA=="})
      .to_return(status: 200, body: issues.to_json, headers: {"Content-Type" => "application/json; charset=utf-8"})

    stub_request(:get, "https://api.github.com/repos/test/example-repo/issues?per_page=100&sort=created&state=all")
      .with(headers: {"Authorization" => "Basic eHh4Onh4eA=="})
      .to_return(status: 200, body: issues.to_json, headers: {"Content-Type" => "application/json; charset=utf-8"})
  end

  scenario "upload gem and select issues" do
    visit "/"
    expect(page).to have_content("ShinyGems")
    click_button "Sign in with GitHub"

    expect(page).to have_content("You don't have any gems")
    click_link "Add your first gem"

    expect(page).to have_content("Select repository")
    select("test/example-repo", from: "repository")
    click_button "Submit"

    expect(page).to have_content("Select issues")
    expect(page).to have_content("Some weird error")
    check("Some weird error")
    click_button "Save"

    expect(page).to have_content("example-gem")
    expect(page).to have_content("example-gem is great gem!")
    expect(page).to have_content("PENDING ISSUES")
    expect(page).to have_content("Some weird error")
    expect(page).to have_content("bug")
  end
end
