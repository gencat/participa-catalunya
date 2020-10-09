# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module Courses
    # This is the engine that runs on the public interface of courses.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Courses

      routes do
        # Add engine routes here
        # resources :courses
        # root to: "courses#index"
      end

      initializer "decidim_courses.assets" do |app|
        app.config.assets.precompile += %w[decidim_courses_manifest.js decidim_courses_manifest.css]
      end
    end
  end
end
