require 'fastlane/action'
require_relative '../helper/xcodetestcoverage_helper'

module Fastlane
  module Actions
    class XcodetestcoverageAction < Action
      def self.run(params)
        enableDataFailedException = params[:enableDataFailedException]
	      minimumCoveragePercentage = params[:minimumCoveragePercentage]
        enableDefaultCoverageException = params[:enableDefaultCoverageException]
        lineCoverage = nil
        coveredLines = nil
        executableLines = nil
        
        filePath = "test.xcresult"
        #filePath = lane_context[SharedValues::SCAN_DERIVED_DATA_PATH] 
        #result = false

        if filePath && File.exists?(filePath)
          jsonResult = sh "xcrun xccov view --only-targets --report #{filePath} --json"          
          if lineCoverageMatch = jsonResult.match('.*"lineCoverage":(\d+.\d+).*')
            lineCoverage = lineCoverageMatch.captures[0]
          end

          if coveredLinesMatch = jsonResult.match('.*"coveredLines":(\d+).*')
            coveredLines = coveredLinesMatch.captures[0]
          end

          if executableLineMatch = jsonResult.match('.*"executableLines":(\d+).*')
            executableLines = executableLineMatch.captures[0]
          end
        end
        
        if !lineCoverage
          params[:dataFailedExceptionCallback].call() if params[:dataFailedExceptionCallback]
          UI.user_error!("Xcodetestcoverage: Test data reading error!") if enableDataFailedException
          return
        end
        
        return {
          "coverage" => lineCoverage,
          "coveredLines" => coveredLines,
          "executableLines" => executableLines
        }
        
        if enableDefaultCoverageException
          puts("SUPER")
        else 
          puts("BAD")
        end
        
        #params[:coverageExceptionCallback].call(minimumCoveragePercentage) if params[:coverageExceptionCallback]


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
	        description: "Minimum acceptable coverage percentage. Call coverageExceptionCallback. Then raise error if overall coverage percentage is under this value and the option enableDefaultCoverageException is enabled",
	        type: Float,
	        optional: true),

        FastlaneCore::ConfigItem.new(
	        key: :enableDefaultCoverageException,
	        env_name: "XCODETESTCOVERAGE_ENABLE_DEFAULT_COVERAGE_EXCEPTION",
	        description: "Raise error if overall coverage percentage is under this minimumCoveragePercentage and this option is enabled",
          optional: true,
          default_value: true,
          is_string: false),

	      FastlaneCore::ConfigItem.new(
	        key: :enableDataFailedException,
	        env_name: "XCODETESTCOVERAGE_ENABLE_DATA_FAILED_EXCEPTION",
	        description: "Raise error if can not read the test data and this option is enabled",
          optional: true,
          default_value: false,
          is_string: false),

	      FastlaneCore::ConfigItem.new(
	        key: :dataFailedExceptionCallback,
	        description: "Optional data failed exception callback argument",
	        optional: true,
	        type: Proc),
        
        FastlaneCore::ConfigItem.new(
	        key: :coverageExceptionCallback,
	        description: "Optional coverage exception callback argument",
	        optional: true,
	        type: Proc)
        ]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end
    end
  end
end
