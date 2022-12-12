# frozen_string_literal: true

require "base64"

module ShinyGems
  module Services
    module Github
      class Gemspec < ShinyGems::Service
        include Deps[octokit: "octokit.global"]

        def call(repo)
          files = octokit.contents(repo).map { |file| file[:name] }

          gemspec_path = Maybe(files.find { |file| file.end_with?(".gemspec") })
          plain_content = gemspec_path.maybe do |path|
            gemspec = octokit.contents(repo, path: path)
            Base64.decode64(gemspec[:content])
          end

          plain_content.to_result(:gemspec_not_found)
        rescue Octokit::Error
          Failure(:gemspec_fetch_failed)
        end
      end
    end
  end
end
