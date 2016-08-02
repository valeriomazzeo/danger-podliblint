module Danger
  # A Danger plugin for Pod lib lint.
  #
  # @example Ensure pod lib lint executes correctly
  #
  # If a log file is specified `lint` will parse it,
  # otherwise it will execute `pod lib lint` and parse the output.
  #
  #          # Optionally specify a log file:
  #          podliblint.log_file = "/tmp/podliblint.log"
  #
  #          # Lint
  #          podliblint.lint
  #
  # @see  valeriomazzeo/danger-podliblint
  # @tags pod, lib, lint, cocoapods
  #
  # @example Ensure pod lib lint executes correctly as part of Fastlane
  #
  # If `pod lib lint` is executed as part of [Fastlane](https://fastlane.tools)
  # is possible to parse the `JUnit` report instead:
  #
  #          # Specify the fastlane report file:
	#          podliblint.log_file = "/fastlane/report.xml"
	#          podliblint.is_fastlane_report = true
  #
  #          # Lint
  #          podliblint.lint
  #
  # @see  valeriomazzeo/danger-podliblint
  # @tags pod, lib, lint, cocoapods
  #
  # @example Ensure pod lib lint executes correctly with custom options
  #
  # Additional `pod lib lint` options can be specified through the `options` variable:
  #
  #          # Specify custom options
	#          podliblint.options = "--allow-warnings --private"
  #
  #          # Lint
  #          podliblint.lint
  #
  # @see  valeriomazzeo/danger-podliblint
  # @tags pod, lib, lint, cocoapods
  #
  class DangerPodliblint < Plugin

    # Allows you to specify a pod lib lint log file location to parse.
    attr_accessor :log_file

    # Allows you to specify if the pod lib lint log has been generated from fastlane.
    attr_accessor :is_fastlane_report

    # Allows you to specify the pod lib lint options.
    # see pod lib lint --help for more information.
    attr_accessor :options

    # Parses and exposes eventual warnings, errors.
    # @return   [failures]
    #
    def lint

      data = nil

      if @log_file != nil
          if @is_fastlane_report
              require 'nokogiri'
              @doc = Nokogiri::XML(File.open(@log_file))
              data = @doc.at_xpath('//testcase[contains(@name, "pod_lib_lint")]/failure/@message').to_s
          else
              data = File.open(@log_file, 'r').read
          end
      else
        podliblint_command = "pod lib lint"
        podliblint_command += " #{@options}" if @options

        require 'cocoapods'
        data = `#{podliblint_command}`
      end

      # Looking for something like:
      # [!] MyProject did not pass validation, due to 1 error and 1 warning.
      lint_summary = data[/(?<=\[!\]\s).*/i]

      if lint_summary
          fail("Pod lib lint: #{lint_summary} 🚨")
          failures = data.scan(/(?<=ERROR\s\|\s).*|(?<=-\s)(?!NOTE|WARN|ERROR).*/i)
          failures.each do |failure|
              fail("`" << ((failure.strip! || failure).gsub!(/`/,"") || failure).to_s << "`")
          end
      else
          message("Pod lib lint passed validation 🎊")
      end

      return failures
    end

    def self.instance_name
          to_s.gsub("Danger", "").danger_underscore.split("/").last
    end

  end
end
