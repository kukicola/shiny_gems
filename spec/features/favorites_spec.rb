# frozen_string_literal: true

RSpec.feature "favorites", type: :feature, js: true do
  let!(:gem) { Factory[:gem, repo: Factory[:repo, name: "my/repo"], downloads: 10, name: "a-special-gem"] }

  scenario "add and remove from favorites" do
    visit "/"

    within ".navbar" do
      click_link "Favorites"
    end

    expect(page).to have_content("You need to sign in to see this page.")
    click_button "Sign in with GitHub", class: "btn-primary"

    expect(page).to have_content("Successfully signed in")
    expect(page).to have_content("Logged as test")
    within ".navbar" do
      click_link "Favorites"
    end

    expect(page).to have_content("You don't have any favorites")
    click_link "Browse all gems"

    expect(page).to have_content("a-special-gem")
    click_link("a-special-gem")

    expect(page).to have_content("Some issue")
    click_button("Add to favorites")

    within ".navbar" do
      click_link "Favorites"
    end
    expect(page).to have_content("Favorites")
    expect(page).to have_content("a-special-gem")
    click_link("a-special-gem")

    expect(page).to have_content("Some issue")
    click_button("Remove from favorites")

    within ".navbar" do
      click_link "Favorites"
    end
    expect(page).to have_content("You don't have any favorites")
  end
end
