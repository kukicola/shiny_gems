# frozen_string_literal: true

module ShinyGems
  class ErrorsMapper
    MAP = {
      source_code_url_doesnt_match: "Neither Source code URL or Homepage URL from RubyGems match GitHub URL",
      gem_already_exists: "Gem already exists",
      gemspec_parse_failed: "Failed to parse gemspec file",
      gem_info_fetch_failed: "Couldn't fetch gem info from RubyGems",
      gemspec_fetch_failed: "Couldn't fetch gemspec from repository",
      repo_fetch_failed: "Couldn't fetch repository from GitHub",
      repos_list_failed: "Couldn't fetch your repositories from GitHub"
    }.freeze

    def call(error)
      MAP[error]
    end
  end
end
