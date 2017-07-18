require File.expand_path('../spec_helper', __FILE__)

module Danger
  describe Danger::DangerPodliblint do
    it 'should be a plugin' do
      expect(Danger::DangerPodliblint.new(nil)).to be_a Danger::Plugin
    end

    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @podliblint = @dangerfile.podliblint
      end

      describe 'with no log_file' do

        it "parses data" do
          expect(@podliblint.lint).not_to be_nil
          expect(@dangerfile.status_report[:errors].first).to eq("Pod lib lint: Unable to find a podspec in the working directory 🚨")
          expect(@dangerfile.status_report[:messages]).to be_empty
          expect(@dangerfile.status_report[:warnings]).to be_empty
          expect(@dangerfile.status_report[:markdowns]).to be_empty
        end
      end

      describe 'with log_file' do

        it "parses data" do
          @podliblint.log_file = "./spec/fixtures/podliblint-error.log"
          expect(@podliblint.lint).not_to be_nil
          expect(@dangerfile.status_report[:errors].first).to eq("Pod lib lint: MyProject did not pass validation, due to 1 error and 1 warning. 🚨")
          expect(@dangerfile.status_report[:errors][1]).to eq("`[iOS] unknown: Encountered an unknown error (Unable to satisfy the following requirements:`")
          #expect(@dangerfile.status_report[:errors][2]).to eq("`SSZipArchive (= 1.2) required by MyProject/FileImportExport (0.1.0)`")
          expect(@dangerfile.status_report[:messages]).to be_empty
          expect(@dangerfile.status_report[:warnings]).to be_empty
          expect(@dangerfile.status_report[:markdowns]).to be_empty
        end

        it "parses pod repo push data" do
          @podliblint.log_file = "./spec/fixtures/podrepopush.log"
          expect(@podliblint.lint).to be_nil
          expect(@dangerfile.status_report[:messages].first).to eq("Pod lib lint passed validation 🎊")
          expect(@dangerfile.status_report[:errors]).to be_empty
          expect(@dangerfile.status_report[:warnings]).to be_empty
          expect(@dangerfile.status_report[:markdowns]).to be_empty
        end

        it "parses pod repo push data errors" do
          @podliblint.log_file = "./spec/fixtures/podrepopush_error.log"
          expect(@podliblint.lint).not_to be_nil
          expect(@dangerfile.status_report[:errors].first).to eq("Pod lib lint: The `AuthenticationProvider.podspec` specification does not validate. 🚨")
          expect(@dangerfile.status_report[:errors][1]).to eq("`xcodebuild:  AuthenticationProvider/Sources/AuthenticationProvider/Models/Permission.swift:85:62: error: cannot invoke 'get' with no arguments`")
          expect(@dangerfile.status_report[:messages]).to be_empty
          expect(@dangerfile.status_report[:warnings]).to be_empty
          expect(@dangerfile.status_report[:markdowns]).to be_empty
        end

        it "succeeds" do
          @podliblint.log_file = "./spec/fixtures/podliblint.log"
          expect(@podliblint.lint).to be_nil
          expect(@dangerfile.status_report[:messages].first).to eq("Pod lib lint passed validation 🎊")
          expect(@dangerfile.status_report[:errors]).to be_empty
          expect(@dangerfile.status_report[:warnings]).to be_empty
          expect(@dangerfile.status_report[:markdowns]).to be_empty
        end

        describe 'with fastlane log_file' do
          it "parses data" do
            @podliblint.log_file = "./spec/fixtures/podliblint-error-fastlane.xml"
            @podliblint.is_fastlane_report = true
            expect(@podliblint.lint).not_to be_nil
            expect(@dangerfile.status_report[:errors].first).to eq("Pod lib lint: MyProject did not pass validation, due to 1 error and 1 warning. 🚨")
            expect(@dangerfile.status_report[:errors][1]).to eq("`[iOS] unknown: Encountered an unknown error (Unable to satisfy the following requirements:`")
            #expect(@dangerfile.status_report[:errors][2]).to eq("`SSZipArchive (= 1.2) required by MyProject/FileImportExport (0.1.0)`")
            expect(@dangerfile.status_report[:messages]).to be_empty
            expect(@dangerfile.status_report[:warnings]).to be_empty
            expect(@dangerfile.status_report[:markdowns]).to be_empty
          end
        end
      end

    end
  end
end
