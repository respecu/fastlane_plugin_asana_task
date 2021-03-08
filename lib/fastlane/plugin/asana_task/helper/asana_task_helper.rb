require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class AsanaTaskHelper
      # class methods that you define here become available in your action
      # as `Helper::AsanaTaskHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the asana_task plugin helper!")
      end
    end
  end
end
