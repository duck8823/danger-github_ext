module Danger
  # This is your plugin class. Any attributes or methods you expose here will
  # be available from within your Dangerfile.
  #
  # To be published on the Danger plugins site, you will need to have
  # the public interface documented. Danger uses [YARD](http://yardoc.org/)
  # for generating documentation from your plugin source, and you can verify
  # by running `danger plugins lint` or `bundle exec rake spec`.
  #
  # You should replace these comments with a public description of your library.
  #
  # @example Whether mergeable
  #
  #          github_ext.mergeable
  #
  # @see  /danger-github_ext
  # @tags
  #
  class DangerGithubExt < DangerfileGitHubPlugin

    # A method that you can call from your Dangerfile
    # @return   [boolean]
    #
    def mergeable
      github.pr_json.attrs[:mergeable_state] == 'clean' && github.pr_json.attrs[:mergeable]
    end
  end
end
