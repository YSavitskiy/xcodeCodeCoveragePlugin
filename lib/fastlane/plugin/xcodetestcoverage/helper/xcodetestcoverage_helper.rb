require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class XcodetestcoverageHelper
    def self.buildElement(element:)
        name = nil
        lineCoverage = nil
        coveredLines = nil
        executableLines = nil
              
        if nameMatch = element.match('"name":"(.*?)"')
          name = nameMatch.captures[0]    
        end
      
        if lineCoverageFloatMatch = element.match('lineCoverage":(\d+.\d+)')
          lineCoverage = lineCoverageFloatMatch.captures[0].to_f * 100
        else 
          if lineCoverageIntMatch = element.match('lineCoverage":(\d+)')
            lineCoverage = lineCoverageIntMatch.captures[0].to_f * 100
          end
        end
        
        if coveredLinesMatch = element.match('coveredLines":(\d+)')
          coveredLines = coveredLinesMatch.captures[0].to_i
        end
      
        if executableLineMatch = element.match('executableLines":(\d+)')
          executableLines = executableLineMatch.captures[0].to_i
        end

        return   {"name" => name,
                  "coverage" => lineCoverage,
                  "coveredLines" => coveredLines,
                  "executableLines" => executableLines}
      end
    end
  end
end
