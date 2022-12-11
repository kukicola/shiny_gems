# frozen_string_literal: true

Hanami.app.register_provider :octokit do
  prepare do
    require "octokit"

    Octokit.configure do |c|
      c.auto_paginate = true
    end
  end

  start do
    register "octokit", Octokit::Client
  end
end
