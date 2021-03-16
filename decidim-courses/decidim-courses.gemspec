# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/courses/version"

Gem::Specification.new do |s|
  s.version = Decidim::Courses.version
  s.authors = ["Víctor"]
  s.email = ["victor.ol@coditramuntana.com"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim-module-courses"
  s.required_ruby_version = ">= 2.6"

  s.name = "decidim-courses"
  s.summary = "A decidim courses module"
  s.description = "."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  decidim_version = "~> 0.23.1"
  s.add_dependency "decidim-core", decidim_version
  s.add_development_dependency "decidim-admin", decidim_version
  s.add_development_dependency "decidim-dev", decidim_version
end
