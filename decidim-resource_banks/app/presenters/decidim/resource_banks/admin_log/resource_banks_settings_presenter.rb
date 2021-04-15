# frozen_string_literal: true

module Decidim
  module ResourceBanks
    module AdminLog
      # This class holds the logic to present a `Decidim::ResourceBanksSetting`
      # for the `AdminLog` log.
      #
      # Usage should be automatic and you shouldn't need to call this class
      # directly, but here's an example:
      #
      #    action_log = Decidim::ActionLog.last
      #    view_helpers # => this comes from the views
      #    ResourceBanksSettingPresenter.new(action_log, view_helpers).present
      class ResourceBanksSettingPresenter < Decidim::Log::BasePresenter
        private

        def action_string
          case action
          when "update"
            "decidim.admin_log.resource_banks_setting.#{action}"
          end
        end
      end
    end
  end
end
