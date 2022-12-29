# frozen_string_literal: true

Core::Slice.register_provider :octokit do
  prepare do
    require "octokit"

    Octokit.configure do |c|
      c.auto_paginate = true
    end
  end

  start do
    register "octokit", Octokit::Client
    register "octokit.global", Octokit::Client.new(client_id: target["settings"].github_key, client_secret: target["settings"].github_secret)
  end
end
