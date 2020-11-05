# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/resource_bank/version"

Gem::Specification.new do |s|
  s.version = Decidim::ResourceBank.version
  s.authors = ["Víctor"]
  s.email = ["victor.ol@coditramuntana.com"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim-module-resource_bank"
  s.required_ruby_version = ">= 2.5"

  s.name = "decidim-resource_bank"
  s.summary = "A decidim resource_bank module"
  s.description = "."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::ResourceBank.version
end
