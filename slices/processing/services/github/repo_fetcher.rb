# frozen_string_literal: true

module Processing
  module Services
    module Github
      class RepoFetcher < ShinyGems::Service
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
