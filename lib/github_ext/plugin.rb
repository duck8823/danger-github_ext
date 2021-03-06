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
  # @example Update the title of the pull request
  #
  #          github.update_pr_tile 'Updated title'
  #
  # @example Update the body of the pull request
  #
  #          github.update_pr_body 'Updated body'
  #
  # @example Close the pull request
  #
  #          github.close
  #
  # @example Open the pull request
  #
  #          github.open
  #
  # @see  duck8823/danger-github_ext
  # @tags github
  #
  class DangerGithubExt < DangerfileGitHubPlugin
    def initialize(dangerfile)
      super(dangerfile)

      api.auto_paginate = true
    end

    # Determine if pull request is mergeable and mergeable status is clean
    # @return   [boolean]
    #
    def mergeable?
      pr_json.attrs[:mergeable_state] == 'clean' && github.pr_json.attrs[:mergeable]
    end

    # List labels for the pull request
    # @return   [[String]]
    # @deprecated Please use {#pr_labels} instead
    #
    def labels
      @repo ||= pr_json.base.repo.full_name
      @number ||= pr_json.number
      api.labels_for_issue(@repo, @number).map(&:name)
    end

    # Add labels to the pull request
    # @param [[String]] labels
    # @return [void]
    #
    def add_labels(labels)
      @repo ||= pr_json.base.repo.full_name
      @number ||= pr_json.number
      api.add_labels_to_an_issue(@repo, @number, Array(labels))
    end

    # Add label with color to the pull request
    # @param [String] label
    # @param [String] color
    # @return [void]
    #
    def add_label(label, color = 'ffffff')
      @repo ||= pr_json.base.repo.full_name
      @number ||= pr_json.number
      api.update_label(@repo, label, color: color)
      api.add_labels_to_an_issue(@repo, @number, Array(label))
    end

    # Remove labels from the pull request
    # @param [[String]] labels
    # @return [void]
    #
    def remove_labels(labels)
      @repo ||= pr_json.base.repo.full_name
      @number ||= pr_json.number
      Array(labels).each do |label|
        api.remove_label(@repo, @number, label)
      end
    end

    # List current statuses for the head commit
    # @return [[Hash]]
    #
    def statuses
      @repo ||= pr_json.base.repo.full_name
      @sha  ||= head_commit
      statuses = {}
      api.statuses(@repo, @sha).each do |status|
        statuses[status.context] ||= []
        statuses[status.context].push(context: status.context,
                                      state: status.state,
                                      date: status.updated_at)
      end
      statuses.map do |_, val|
        val.sort { |a, b| b[:date] <=> a[:date] }[0]
      end
    end

    # Update the title of the pull request
    # @return [Sawyer::Resource]
    #
    def update_pr_title(title)
      @repo ||= pr_json.base.repo.full_name
      @number ||= pr_json.number
      api.update_pull_request(@repo, @number, title: title)
    end

    # Update the body of pull request
    # @return [Sawyer::Resource]
    #
    def update_pr_body(body)
      @repo ||= pr_json.base.repo.full_name
      @number ||= pr_json.number
      api.update_pull_request(@repo, @number, body: body)
    end

    # Update the pull request state
    # @return [Sawyer::Resource]
    #
    def update_pr_state(state)
      @repo ||= pr_json.base.repo.full_name
      @number ||= pr_json.number
      api.update_pull_request(@repo, @number, state: state)
    end
  end
end
