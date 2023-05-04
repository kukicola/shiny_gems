#!/bin/bash

HANAMI_SLICES=processing bundle exec sidekiq -r ./config/sidekiq.rb -e production
