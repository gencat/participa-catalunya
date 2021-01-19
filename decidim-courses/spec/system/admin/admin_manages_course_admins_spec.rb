# frozen_string_literal: true

require "spec_helper"

describe "Admin manages course admins", type: :system do
  include_context "when admin administrating a course"

  it_behaves_like "manage course admins examples"
end
