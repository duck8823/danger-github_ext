module Danger
  # This is Danger Plugin for GitHub extension.
  # When installing this plugin, you can additional methods on github instance
  #
  # @example Determine if pull request is mergeable and mergeable status is clean
  #
  #          github.mergeable?
  #
  # @example List labels for the pull request
  #
  #          github.labels
  #
  # @example Add labels to the pull request
  #
  #          github.add_labels 'build ok'
  #
  # @example Remove labels from the pull request
  #
  #          github.remove_labels 'build failed'
  #
  # @example List current statuses for the head commit
  #
  #          github.statuses
  #
  # @see  duck8823/danger-github_ext
  # @tags github
  #
  class DangerGithubExt < DangerfileGitHubPlugin

    def initialize(dangerfile)
      super(dangerfile)

      self.api.auto_paginate = true
    end

    # Whether mergeable and mergeable status is clean
    # @return   [boolean]
    #
    def mergeable?
      self.pr_json.attrs[:mergeable_state] == 'clean' && github.pr_json.attrs[:mergeable]
    end

    # Get labels
    # @return   [[String]]
    #
    def labels
      @repo ||= self.pr_json.base.repo.full_name
      @number ||= self.pr_json.number
      self.api.labels_for_issue(@repo, @number).map { |issue|
        issue.name
      }
    end

    # add labels to pull request
    # @param [[String]] labels
    # @return [void]
    #
    def add_labels(labels)
      @repo ||= self.pr_json.base.repo.full_name
      @number ||= self.pr_json.number
      self.api.add_labels_to_an_issue(@repo, @number, Array(labels))
    end

    # remove labels from pull request
    # @param [[String]] labels
    # @return [void]
    #
    def remove_labels(labels)
      @repo ||= self.pr_json.base.repo.full_name
      @number ||= self.pr_json.number
      Array(labels).each do |label|
        self.api.remove_label(@repo, @number, label)
      end
    end

    # get current commit statuses
    # @return [[Hash]]
    #
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
