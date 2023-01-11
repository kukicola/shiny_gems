# frozen_string_literal: true

module Processing
  module Services
    module Github
      class RepoFetcher < ShinyGems::Service
        include Deps["octokit"]

        def call(name)
          Success(octokit.repo(name))
        rescue Octokit::Error => e
          Failure(e)
        end
      end
    end
  end
end
