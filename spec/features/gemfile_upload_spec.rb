# frozen_string_literal: true

RSpec.feature "gemfile upload", type: :feature, js: true do
  let!(:gem) { Factory[:gem, :with_issues, name: "hanami", repo: "my/repo"] }
  let!(:other_gem) { Factory[:gem, :with_issues] }

  scenario "browse gems by uploaded gemfile" do
    visit "/gems"
    expect(page).to have_content("Browse gems")
    expect(page).to have_content(gem.name)
    expect(page).to have_content(other_gem.name)

    attach_file("gemfile", "#{SPEC_ROOT}/support/files/Gemfile.test", visible: false)

    expect(page).to have_content("Gems from your Gemfile")
    expect(page).to have_content(gem.name)
    expect(page).to have_no_content(other_gem.name)
  end
end
