# frozen_string_literal: true

module Core
  module Services
    module Gems
      class Creator < Core::Service
        include Deps["services.gems.gemspec_name_parser", "services.gems.rubygems_info_fetcher", "services.github.gemspec_fetcher",
          "services.github.repos_list_fetcher", "repositories.gems_repository"]

        def call(user:, repo:)
          repo_data = yield fetch_repo(user: user, repo: repo)
          gemspec_content = yield gemspec_fetcher.call(repo)
          gem_name = yield gemspec_name_parser.call(gemspec_content)
          basic_info = yield rubygems_info_fetcher.call(gem_name)
          yield validate_source_code_url(info: basic_info, repo: repo)
          gem = yield save_gem(info: basic_info, repo_data: repo_data, user: user)
          Success(gem)
        end

        private

        def fetch_repo(user:, repo:)
          list = yield repos_list_fetcher.call(user)
          repo_data = list.find { |r| r[:full_name] == repo }
          Maybe(repo_data).to_result(:repo_ownership_check_failed)
        end

        def validate_source_code_url(info:, repo:)
          repo_url = "https://github.com/#{repo}"

          if info["homepage_uri"] == repo_url || info["source_code_uri"] == repo_url
            Success()
          else
            Failure(:source_code_url_doesnt_match)
          end
        end

        def save_gem(info:, repo_data:, user:)
          attributes = {
            name: info["name"],
            repo: repo_data[:full_name],
            description: info["info"],
            stars: repo_data[:stargazers_count],
            downloads: info["downloads"],
            user_id: user.id
          }

          Success(gems_repository.create(attributes))
        rescue ROM::SQL::UniqueConstraintError
          Failure(:gem_already_exists)
        end
      end
    end
  end
end