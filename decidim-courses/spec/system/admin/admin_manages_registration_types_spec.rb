# frozen_string_literal: true

require "spec_helper"

describe "Admin manages registration types", type: :system do
  include_context "when admin administrating a course"

  it_behaves_like "manage registration types examples"
end
