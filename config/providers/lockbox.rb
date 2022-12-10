# frozen_string_literal: true

Hanami.app.register_provider :lockbox do
  prepare do
    require "lockbox"
  end

  start do
    register "lockbox", Lockbox.new(key: target["settings"].lockbox_master_key, encode: true)
  end
end
