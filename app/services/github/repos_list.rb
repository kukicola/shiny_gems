# frozen_string_literal: true

require "dry/monads"

module ShinyGems
  module Services
    module Github
      class ReposList < ShinyGems::Service
        include Deps["octokit"]

        def call(user)
          Success(octokit.new(access_token: user.github_token).repos({}, query: {sort: "asc"}).map { |repo| repo[:full_name] })
        rescue Octokit::Error
          Failure(:repos_list_failed)
        end
      end
    end
  end
end
