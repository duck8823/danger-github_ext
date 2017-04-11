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

    def initialize(dangerfile)
      super(dangerfile)

      self.api.auto_paginate = true
    end

    # A method that you can call from your Dangerfile
    # @return   [boolean]
    #
    def mergeable?
      self.pr_json.attrs[:mergeable_state] == 'clean' && github.pr_json.attrs[:mergeable]
    end

    def labels
      @repo ||= self.pr_json.base.repo.full_name
      @number ||= self.pr_json.number
      self.api.labels_for_issue(@repo, @number).map { |issue|
        issue.name
      }
    end

    def add_labels(labels)
      @repo ||= self.pr_json.base.repo.full_name
      @number ||= self.pr_json.number
      self.api.add_labels_to_an_issue(@repo, @number, Array(labels))
    end

    def remove_labels(labels)
      @repo ||= self.pr_json.base.repo.full_name
      @number ||= self.pr_json.number
      Array(labels).each do |label|
        self.api.remove_label(@repo, @number, label)
      end
    end

    def statuses
      @repo ||= self.pr_json.base.repo.full_name
      @sha  ||= self.head_commit
      statuses = {}
      self.api.statuses(@repo, @sha).each do |status|
        statuses[status.context] ||= []
        statuses[status.context].push({
                                          context: status.context,
                                          state: status.state,
                                          date: status.updated_at
                                      })
      end
      statuses.map {|_, val|
        val.sort{|a, b| b[:date] <=> a[:date] }[0]
      }
    end
  end
end
