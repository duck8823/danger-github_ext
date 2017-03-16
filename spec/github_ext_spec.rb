require File.expand_path('../spec_helper', __FILE__)

module Danger
  describe Danger::DangerGithubExt do
    it 'should be a plugin' do
      expect(Danger::DangerGithubExt.new(nil)).to be_a Danger::Plugin
    end

    #
    # You should test your custom attributes and methods here
    #
    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @my_plugin = @dangerfile.github_ext
      end

      # Some examples for writing tests
      # You should replace these with your own.

    end
  end
end
