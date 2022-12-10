# frozen_string_literal: true

RSpec.feature "auth", type: :feature do
  scenario "sign in and out" do
    visit "/"
    expect(page).to have_content("ShinyGems")
    click_button "Sign in with GitHub"

    expect(page).to have_content("Successfully signed in")
    expect(page).to have_content("Logged as test")
    expect(page).not_to have_content("Sign in with GitHub")

    find('a[aria-label="sign out"]').click
    expect(page).to have_content("Successfully signed out")
    expect(page).to have_content("Sign in with GitHub")
  end
end
