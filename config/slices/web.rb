# frozen_string_literal: true

module Web
  class Slice < Hanami::Slice
    import from: :core

    config.actions.content_security_policy[:form_action] += " https://github.com"
    config.actions.content_security_policy[:script_src] += " https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js https://static.cloudflareinsights.com/beacon.min.js/"
    config.actions.content_security_policy[:font_src] += " https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.2/font/fonts/"
  end
end
