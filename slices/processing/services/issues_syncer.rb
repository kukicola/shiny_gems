# frozen_string_literal: true

module Processing
  module Services
    class IssuesSyncer < ShinyGems::Service
      include Deps["services.github.issues_list_fetcher", "repositories.issues_repository"]

      def call(gem)
        list = yield issues_list_fetcher.call(gem.repo)
        github_ids = list.map { |gh_issue| gh_issue[:id] }
        issues_to_remove = gem.issues.reject { |issue| github_ids.include?(issue.github_id) }

        issues_repository.transaction do
          list.each do |gh_issue|
            existing_issue = gem.issues.find { |issue| issue.github_id == gh_issue[:id] }

            if existing_issue
              issues_repository.update(existing_issue.id, issue_attributes(gh_issue))
            else
              issues_repository.create(issue_attributes(gh_issue).merge({gem_id: gem.id}))
            end
          end

          issues_to_remove.each do |issue|
            issues_repository.delete(issue.id)
          end
        end

        Success()
      end

      private

      def issue_attributes(gh_issue)
        {
          github_id: gh_issue[:id],
          title: gh_issue[:title],
          url: gh_issue[:html_url],
          comments: gh_issue[:comments],
          created_at: DateTime.parse(gh_issue[:created_at]),
          labels: gh_issue[:labels].map { |label| label.to_h.slice(:name, :color) }
        }
      end
    end
  end
end
