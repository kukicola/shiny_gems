# frozen_string_literal: true

module Web
  class ErrorsMapper
    MAP = {
      source_code_url_doesnt_match: "Neither Source code URL or Homepage URL from RubyGems match GitHub URL",
      gem_already_exists: "Gem already exists",
      gemspec_parse_failed: "Couldn't parse gemspec file",
      gem_info_fetch_failed: "Couldn't fetch gem info from RubyGems",
      gemspec_fetch_failed: "Couldn't fetch gemspec from repository",
      repo_fetch_failed: "Couldn't fetch repository from GitHub",
      repos_list_failed: "Couldn't fetch your repositories from GitHub",
      issues_list_failed: "Couldn't fetch issues from GitHub",
      no_gems_in_gemfile: "No gems found in file, are you sure it's a correct Gemfile?",
      gemfile_parse_failed: "Couldn't parse gemfile"
    }.freeze

    def call(error)
      MAP[error]
    end
  end
end
