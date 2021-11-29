# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { git: "https://github.com/CodiTramuntana/decidim", branch: "release/0.23-stable" }.freeze

gem "decidim", DECIDIM_VERSION
gem "decidim-conferences", DECIDIM_VERSION
gem "decidim-courses", path: "./decidim-courses"
gem "decidim-resource_banks", path: "./decidim-resource_banks"
gem "decidim-term_customizer", "~> 0.23.0", git: "https://github.com/mainio/decidim-module-term_customizer.git", branch: "0.23-stable"

gem "decidim-department_admin", "~> 0.2.1", git: "https://github.com/gencat/decidim-module-department_admin.git", branch: "0.2-stable"

gem "bootsnap", "~> 1.3"
gem "rails", "< 6"
# remove the forcing of the execjs version when upgrading to rails 6
gem "execjs", "2.7.0"

gem "puma", ">= 4.3.5"
gem "uglifier", "~> 4.1"

gem "deface"
gem "faker", "~> 1.9"
gem "figaro"
gem "whenever"
gem "wicked_pdf"

group :development, :test do
  gem "byebug", "~> 11.1", platform: :mri
  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 3.5"
end

group :production, :preprod do
  gem "daemons"
  gem "delayed_job_active_record"
end
