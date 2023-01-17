# frozen_string_literal: true

module Processing
  module Services
    module Github
      class IssuesListFetcher < ShinyGems::Service
        include Deps[:octokit]

        def call(repo)
          Success(octokit.list_issues(repo, state: "open", labels: "help wanted").reject { |issue| issue[:pull_request] })
        rescue Octokit::Error => e
          Failure(e)
        end
      end
    end
  end
end
