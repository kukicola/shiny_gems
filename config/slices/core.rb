# frozen_string_literal: true

module Core
  class Slice < Hanami::Slice
    export [
      "services.gems.issues.updater",
      "services.gems.syncer",
      "services.github.issues_list_fetcher",
      "services.github.repos_list_fetcher",
      "services.gems.creator",
      "services.gems.gemfile_parser"
    ]
  end
end
