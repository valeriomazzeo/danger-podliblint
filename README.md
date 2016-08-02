# danger-podliblint

[![Gem Version](https://badge.fury.io/rb/danger-podliblint.svg)](https://badge.fury.io/rb/danger-podliblint) [![Build Status](https://travis-ci.org/valeriomazzeo/danger-podliblint.svg?branch=master)](https://travis-ci.org/valeriomazzeo/danger-podliblint)

A Danger plugin for Pod lib lint.

## Installation

    $ gem install danger-podliblint

## Usage

If a log file is specified `lint` will parse it, otherwise it will execute `pod lib lint` and parse the output.

	# Optionally specify a log file:
	podliblint.log_file = "/tmp/podliblint.log"

	# Lint
	podliblint.lint

## Development

1. Clone this repo
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake spec` to run the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.
