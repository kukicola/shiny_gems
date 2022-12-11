# frozen_string_literal: true

module ShinyGems
  module Services
    module Github
      class ReposList
        include Deps["octokit"]

        def call(user)
          octokit.new(access_token: user.github_token).repos({}, query: {sort: "asc"}).map { |repo| repo[:full_name] }
        end
      end
    end
  end
end
