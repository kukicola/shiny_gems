# frozen_string_literal: true

require "hanami/boot"
require "rack/static"

use Rack::Static, urls: ["/assets"], root: "public"
use OmniAuth::Builder do
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
end

run Hanami.app
