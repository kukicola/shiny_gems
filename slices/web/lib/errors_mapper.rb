# frozen_string_literal: true

module Web
  class ErrorsMapper
    MAP = {
      no_gems_in_gemfile: "No gems found in file, are you sure it's a correct Gemfile?",
      gemfile_parse_failed: "Couldn't parse gemfile"
    }.freeze

    def call(error)
      MAP[error]
    end
  end
end
