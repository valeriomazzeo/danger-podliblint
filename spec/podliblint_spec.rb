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

      it "is parses data" do

      end

    end
  end
end
