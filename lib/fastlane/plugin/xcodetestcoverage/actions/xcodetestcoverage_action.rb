require 'fastlane/action'
require_relative '../helper/xcodetestcoverage_helper'

module Fastlane
  module Actions
    class XcodetestcoverageAction < Action
      def self.run(params)
        enableDataFailedException = params[:enableDataFailedException]
	      minimumCoveragePercentage = params[:minimumCoveragePercentage]
        enableDefaultCoverageException = params[:enableDefaultCoverageException]
        targetName = params[:testTargetName]
        filePath = params[:xcresultPath]
        foundElement = nil     
        
        if !filePath 
          filePath = lane_context[SharedValues::SCAN_GENERATED_XCRESULT_PATH]
        end

        if filePath && File.exists?(filePath)
          jsonResult = sh "xcrun xccov view --only-targets --report '#{filePath}' --json"

          #regex, reason: json parse does not work correctly
          if resultMatch = jsonResult.match('(\[.*lineCoverage.*\])')
            jsonArray = resultMatch.captures[0]
          end

          elements = Array.new()    
          element = ""
          for pos in 0...jsonArray.length
            if jsonArray[pos].chr == "}"
              elements.push Helper::XcodetestcoverageHelper.buildElement(element: element)
              element = ""
            else         
              element = element + jsonArray[pos].chr
            end
          end

          if elements.length > 0 
            for index in 0...elements.length              
              if targetName && elements[index]["name"] && elements[index]["name"] == targetName
                foundElement = elements[index]              
              break
              end
              
              if !foundElement || (elements[index]["coverage"] && elements[index]["coverage"] > foundElement["coverage"])
                foundElement = elements[index]                
              end
            end
          else 
            foundElement = Helper::XcodetestcoverageHelper.buildElement(element: jsonResult)
          end
        end

        lineCoverage = foundElement["coverage"]
   
        UI.message("Xcodetestcoverage: name: #{foundElement["name"]}")
        UI.message("Xcodetestcoverage: coverage: #{lineCoverage}")
        UI.message("Xcodetestcoverage: coveredLines: #{foundElement["coveredLines"]}")
        UI.message("Xcodetestcoverage: executableLines: #{foundElement["executableLines"]}")

        if !lineCoverage
          params[:dataFailedExceptionCallback].call() if params[:dataFailedExceptionCallback]
          UI.user_error!("Xcodetestcoverage: Test data reading error!") if enableDataFailedException
          return
        end

        if minimumCoveragePercentage && lineCoverage < minimumCoveragePercentage
          params[:coverageExceptionCallback].call(minimumCoveragePercentage) if params[:coverageExceptionCallback]
          UI.user_error!("Xcodetestcoverage: Coverage percentage is less than #{minimumCoveragePercentage} (minimumCoveragePercentage)") if enableDefaultCoverageException
        end
        
        return foundElement
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
	        type: Proc),
        
        FastlaneCore::ConfigItem.new(
          key: :testTargetName,
          env_name: "XCODETESTCOVERAGE_TEST_TARGET_NAME",
          description: "Alternative path to xcresult",
          type: String,
          optional: true),

        FastlaneCore::ConfigItem.new(
          key: :xcresultPath,
          env_name: "XCODETESTCOVERAGE_XCRESULTPATH",
          description: "Alternative path to xcresult",
          type: String,
          optional: true)
        ]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end
    end
  end
end
