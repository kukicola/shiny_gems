# frozen_string_literal: true

module Core
  module Services
    module Github
      class ReposListFetcher < Core::Service
        include Deps["octokit"]

        def call(user)
          Success(octokit.new(access_token: user.github_token).repos({}, query: {sort: "asc"}))
        rescue Octokit::Error
          Failure(:repos_list_failed)
        end
      end
    end
  end
end
