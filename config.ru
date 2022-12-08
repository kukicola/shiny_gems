# frozen_string_literal: true

require "hanami/boot"
require "rack/static"

use Rack::Static, urls: ["/assets"], root: "public"

run Hanami.app
