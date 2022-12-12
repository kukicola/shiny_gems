# frozen_string_literal: true

module ShinyGems
  module Services
    module Github
      class Repo < ShinyGems::Service
        include Deps[octokit: "octokit.global"]

        def call(name)
          Success(octokit.repo(name))
        rescue Octokit::Error
          Failure(:repo_fetch_failed)
        end
      end
    end
  end
end
