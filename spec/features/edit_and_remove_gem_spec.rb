# frozen_string_literal: true

RSpec.feature "edit and remove gem", type: :feature, js: true do
  let!(:user) { Factory[:user, github_id: 235352] }
  let!(:gem) { Factory[:gem, user: user.attributes, name: "a-special-gem", repo: "my/repo"] }
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
    stub_request(:get, "https://api.github.com/repos/my/repo/issues?per_page=100&sort=created&state=open")
      .with(headers: {"Authorization" => "Basic eHh4Onh4eA=="})
      .to_return(status: 200, body: issues.to_json, headers: {"Content-Type" => "application/json; charset=utf-8"})

    stub_request(:get, "https://api.github.com/repos/my/repo/issues?per_page=100&sort=created&state=all")
      .with(headers: {"Authorization" => "Basic eHh4Onh4eA=="})
      .to_return(status: 200, body: issues.to_json, headers: {"Content-Type" => "application/json; charset=utf-8"})
  end

  scenario "edit existing issues" do
    visit "/"
    expect(page).to have_content("ShinyGems")
    click_button "Sign in with GitHub"

    expect(page).to have_content("My gems")
    expect(page).to have_content("a-special-gem")
    click_link "a-special-gem"

    expect(page).to have_content("There are no pending issues")
    click_link("Edit issues")

    expect(page).to have_content("Select issues")
    expect(page).to have_content("Some weird error")
    check("Some weird error")
    click_button "Save"

    expect(page).to have_content("PENDING ISSUES")
    expect(page).to have_content("Some weird error")
    expect(page).to have_no_content("There are no pending issues")
    click_link("Edit issues")

    expect(page).to have_content("Select issues")
    expect(page).to have_content("Some weird error")
    uncheck("Some weird error")
    click_button "Save"

    expect(page).to have_content("There are no pending issues")
  end

  scenario "delete gem" do
    visit "/"
    expect(page).to have_content("ShinyGems")
    click_button "Sign in with GitHub"

    expect(page).to have_content("My gems")
    expect(page).to have_content("a-special-gem")
    click_link "a-special-gem"

    expect(page).to have_content("There are no pending issues")
    page.accept_confirm { click_button "Remove gem" }

    expect(page).to have_content("You don't have any gems")
  end
end
