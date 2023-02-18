require 'fastlane/action'
require_relative '../helper/xcodetestcoverage_helper'

module Fastlane
  module Actions
    class XcodetestcoverageAction < Action
      def self.run(params)
        UI.message("The xcodetestcoverage plugin is working!")
      end

      def self.description
        "plugin for getting test data from Xcode"
      end

      def self.authors
        ["Yury Savitsky"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "plugin for getting test data from Xcode"
      end

      def self.available_options
        [
          # FastlaneCore::ConfigItem.new(key: :your_option,
          #                         env_name: "XCODETESTCOVERAGE_YOUR_OPTION",
          #                      description: "A description of your option",
          #                         optional: false,
          #                             type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
