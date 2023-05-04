#!/bin/bash

HANAMI_SLICES=web bundle exec puma -C config/puma.rb
