# xcodetestcoverage plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-xcodetestcoverage)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-xcodetestcoverage`, add it to your project by running:

```bash
fastlane add_plugin xcodetestcoverage
```

## About xcodetestcoverage

Plugin for getting test data from Xcode

It has to be run after tests.
Returns hash contains keys: coverage, coveredLines, executableLines:

```bash
run_tests()
result = xcodetestcoverage()
puts(result["coverage"])
puts(result["coveredLines"])
puts(result["executableLines"])	
```

parameters: 

minimumCoveragePercentage - Minimum acceptable coverage percentage. Call coverageExceptionCallback. Then raise error if overall coverage percentage is under this value and the option enableDefaultCoverageException is enabled", type: Float, optional: true.

enableDefaultCoverageException - Raise error if overall coverage percentage is under this minimumCoveragePercentage and this option is enabled, optional: true, default_value: true

enableDataFailedException - Raise error if can not read the test data and this option is enabled optional: true, default_value: false

dataFailedExceptionCallback - Optional data failed exception callback argument, optional: true,
type: Proc

coverageExceptionCallback - Optional coverage exception callback argument" optional: true, type: Proc

xcresultPath - alternative path to xcresult, optional: true, type: String

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane tests`.

If you need to throw an exception on coverage percantage, set the parameter minimumCoveragePercentage. If you want to call your code in this case set coverageExceptionCallback. 
You can disable defaultException if you set enableDefaultCoverageException = false.

```bash
xcodetestcoverage(minimumCoveragePercentage: 40.0,
                  coverageExceptionCallback: ->(value) { 
                  	UI.message("Test coverage failed #{value}") 
                  })
```

If you need to throw an exception on test data read error, set the parameter enableDataFailedException = true. If you want to call your code in this case set dataFailedExceptionCallback.

```bash
xcodetestcoverage(minimumCoveragePercentage: 45.0,
                  enableDataFailedException: true,
                  dataFailedExceptionCallback: ->() { 
			UI.message("Data reading error")
		  }
)
```
You can use alternative path to xcresult. In this case, running a test via fastlane (with the command scan or run_tests) before xcodetestcoverage is optional.
```bash
 reportPath = "test.xcresult"
 xcodetestcoverage(minimumCoveragePercentage: 30.0,
 		   enableDataFailedException: true,
                   xcresultPath: reportPath)
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
