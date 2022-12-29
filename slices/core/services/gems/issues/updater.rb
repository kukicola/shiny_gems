# frozen_string_literal: true

module Core
  module Services
    module Gems
      module Issues
        class Updater < Core::Service
          include Deps["services.github.issues_list_fetcher", "repositories.issues_repository"]

          def call(gem:, issues_ids:)
            list = yield issues_list_fetcher.call(gem.repo, all: true)

            issues_repository.transaction do
              list.each do |gh_issue|
                existing_issue = gem.issues.find { |issue| issue.github_id == gh_issue[:id] }

                if existing_issue
                  if gh_issue[:state] == "open" && issues_ids.include?(gh_issue[:id])
                    update(existing_issue, gh_issue)
                  else
                    delete(existing_issue)
                  end
                elsif issues_ids.include?(gh_issue[:id])
                  create(gh_issue, gem)
                end
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
              labels: gh_issue[:labels].map { |label| label.to_h.slice(:name, :color) }
            }
          end

          def update(issue, gh_issue)
            issues_repository.update(issue.id, issue_attributes(gh_issue))
          end

          def create(gh_issue, gem)
            issues_repository.create(issue_attributes(gh_issue).merge({gem_id: gem.id}))
          end

          def delete(issue)
            issues_repository.delete(issue.id)
          end
        end
      end
    end
  end
end
