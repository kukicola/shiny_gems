# frozen_string_literal: true

RSpec.feature "browse", type: :feature, js: true do
  let!(:gem) { Factory[:gem, repo: Factory[:repo, name: "my/repo"], downloads: 10, name: "a-special-gem"] }

  before do
    30.times do
      Factory[:gem]
    end
  end

  scenario "browse gems" do
    visit "/gems"
    expect(page).to have_content("Browse gems")
    expect(page).to have_no_content(gem.name)

    click_link("2", class: "page-link")
    expect(page).to have_content(gem.name)

    click_link(gem.name)
    expect(page).to have_content("Some issue")

    expect(page).to have_content("GitHub Repository\nmy/repo")
    expect(page).to have_content("GitHub Stars\n1,521")
    expect(page).to have_content("RubyGems Downloads\n10")
  end
end
