# frozen_string_literal: true

module ShinyGems
  module Services
    module Github
      class IssuesList < ShinyGems::Service
        include Deps[octokit: "octokit.global"]

        def call(repo, all: false)
          Success(octokit.list_issues(repo, sort: "created", state: all ? "all" : "open").reject { |issue| issue[:pull_request] })
        rescue Octokit::Error
          Failure(:issues_list_failed)
        end
      end
    end
  end
end
