# frozen_string_literal: true

module Processing
  module Services
    class Discover < ShinyGems::Service
      include Deps["services.rubygems.list_fetcher", "repositories.gems_repository", "repositories.repos_repository"]

      GITHUB_REPO_REGEX = %r{https?://github.com/([^/#]+/[^/#]+)}

      def call(page: 1)
        gems = yield list_fetcher.call(page: page)

        return Failure(:no_results) if gems.empty?

        existing_gem_names = gems_repository.pluck_name_by_list(gems.map { |gem| gem["name"] })
        missing_gems = gems.reject { |gem| existing_gem_names.include?(gem["name"]) }
        created_gems = gems_repository.transaction do
          missing_gems.map(&method(:attempt_create)).compact
        end
        Success(created_gems)
      end

      private

      def attempt_create(gem)
        github_repo = extract_github_repo(gem)
        return unless github_repo

        repo = repos_repository.find_or_create({name: github_repo})

        gems_repository.create({
          name: gem["name"],
          repo_id: repo.id
        })
      end

      def extract_github_repo(gem)
        gem["homepage_uri"]&.match(GITHUB_REPO_REGEX)&.[](1) || gem["source_code_uri"]&.match(GITHUB_REPO_REGEX)&.[](1)
      end
    end
  end
end
