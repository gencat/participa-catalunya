# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { git: 'https://github.com/decidim/decidim', branch: 'release/0.22-stable' }.freeze

gem "decidim", DECIDIM_VERSION
gem "decidim-consultations", DECIDIM_VERSION
gem "decidim-initiatives", DECIDIM_VERSION
gem "decidim-courses", path: "./decidim-courses"
gem "decidim-resource_bank", path: "./decidim-resource_bank"

gem "bootsnap", "~> 1.3"

gem "puma", ">= 4.3.5"
gem "uglifier", "~> 4.1"

gem "wicked_pdf"
gem "faker", "~> 1.9"
gem "figaro"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri
  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 3.5"
end

group :production do
  gem 'delayed_job_active_record'
  gem "daemons"
end
