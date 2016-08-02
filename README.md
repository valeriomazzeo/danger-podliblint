# danger-podliblint

[![Gem Version](https://badge.fury.io/rb/danger-podliblint.svg)](https://badge.fury.io/rb/danger-podliblint) [![Build Status](https://travis-ci.org/valeriomazzeo/danger-podliblint.svg?branch=master)](https://travis-ci.org/valeriomazzeo/danger-podliblint)

A Danger plugin for Pod lib lint.

## Installation

    $ gem install danger-podliblint

## Usage

### Log file

If a log file is specified `lint` will parse it, otherwise it will execute `pod lib lint` and parse the output.

	# Optionally specify a log file:
	podliblint.log_file = "/tmp/podliblint.log"

	# Lint
	podliblint.lint
	
### Fastlane Report

If `pod lib lint` is executed as part of [Fastlane](https://fastlane.tools) is possible to parse the `JUnit` report instead:

	# Specify the fastlane report file:
	podliblint.log_file = "/fastlane/report.xml"
	podliblint.is_fastlane_report = true
	
	# Lint
	podliblint.lint
	
### Options

Additional `pod lib lint` options can be specified through the `options` variable:

	# Specify custom options
	podliblint.options = "--allow-warnings --private"
	
	# Lint
	podliblint.lint
	
**Note:** options are ignored when `log_file` is set.

## Development

1. Clone this repo
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake spec` to run the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.
