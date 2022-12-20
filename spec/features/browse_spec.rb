# frozen_string_literal: true

RSpec.feature "browse", type: :feature, js: true do
  let!(:gem) { Factory[:gem, :with_issues, downloads: 10, name: "a-special-gem", repo: "my/repo"] }

  before do
    30.times do
      Factory[:gem, :with_issues]
    end
  end

  scenario "browse gems" do
    visit "/gems"
    expect(page).to have_content("Browse gems")
    expect(page).to have_content(gem.name)

    select("Downloads", from: "sort_by")
    expect(page).to have_no_content(gem.name)

    click_link("2", class: "page-link")
    expect(page).to have_content(gem.name)

    click_link(gem.name)
    expect(page).to have_content("PENDING ISSUES")
    expect(page).to have_content("Some issue")

    expect(page).to have_content("GitHub Repository\nmy/repo")
    expect(page).to have_content("GitHub Stars\n1,521")
    expect(page).to have_content("RubyGems Downloads\n10")
  end
end
