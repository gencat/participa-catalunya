# frozen_string_literal: true

require "spec_helper"

describe "Admin manages resource_bank admins", type: :system do
  include_context "when admin administrating a resource"

  it_behaves_like "manage resource admins examples"
end
