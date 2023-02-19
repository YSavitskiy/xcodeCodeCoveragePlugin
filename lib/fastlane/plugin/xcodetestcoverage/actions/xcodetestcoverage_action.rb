require 'fastlane/action'
require_relative '../helper/xcodetestcoverage_helper'

module Fastlane
  module Actions
    class XcodetestcoverageAction < Action
      def self.run(params)
#	minimumCoveragePercentage = params[:minimumCoveragePercentage]
#        enableException = params[:enableException]

#	if minimumCoveragePercentage
#	  UI.message("Percentage #{minimumCoveragePercentage}")
#	end

#	if enableException
#	  UI.message("Eception")
#	end

	UI.message("Testw4 The xcodetestcoverage plugin is working!")
	"test"        
      end

      def self.description
        "plugin for getting coverage test data from Xcode"
      end

      def self.authors
        ["Yury Savitsky"]
      end

      def self.return_value
	"returns hash contains keys: coverage, coveredLines, executableLines"
      end

      def self.details
        "plugin for getting test data from Xcode"
      end

      def self.available_options
	[
	FastlaneCore::ConfigItem.new(
	  	key: :minimumCoveragePercentage,
		env_name: "XCODETESTCOVERAGE_MINIMUM_COVERAGE_PERCENTAGE",
		description: "Minimum acceptable coverage percentage. Raise error if overall coverage percentage is under this value and the option enableException is enabled",
		type: String,
		optional: true
	),

	FastlaneCore::ConfigItem.new(
		key: : enableException,
		env_name: "XCODETESTCOVERAGE_MINIMUM_COVERAGE_PERCENTAGE",
		description: "Raise error if overall coverage percentage is under this minimumCoveragePercentage and this option is enabled",
  		optional: true,
  		default_value: true,
  		is_string: false)
        ]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end
    end
  end
end
