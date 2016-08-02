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
  class DangerPodliblint < Plugin

    def initialize(arg)
      super
      @warning_count = 0
      @error_count = 0
      @test_failures_count = 0
    end

    # Allows you to specify a pod lib lint log file location to parse.
    attr_accessor :log_file

    # Parses and exposes eventual warnings.
    # @return   [warning_count]
    #
    def lint

      data = nil

      if @log_file?
        data = File.open(@log_file).read
      else
        require 'cocoapods'
        data = pod lib lint
      end

    end

    def lint(data)

    end

    def self.instance_name
          to_s.gsub("Danger", "").danger_underscore.split("/").last
    end
  end
end
