

### github_ext

This is Danger Plugin for GitHub extension.
When installing this plugin, you can additional methods on github instance

<blockquote>Determine if pull request is mergeable and mergeable status is clean
  <pre>
github.mergeable?</pre>
</blockquote>

<blockquote>List labels for the pull request
  <pre>
github.labels</pre>
</blockquote>

<blockquote>Add labels to the pull request
  <pre>
github.add_labels 'build ok'</pre>
</blockquote>

<blockquote>Remove labels from the pull request
  <pre>
github.remove_labels 'build failed'</pre>
</blockquote>

<blockquote>List current statuses for the head commit
  <pre>
github.statuses</pre>
</blockquote>

<blockquote>Update the title of the pull request
  <pre>
github.update_pr_tile 'Updated title'</pre>
</blockquote>

<blockquote>Update the body of the pull request
  <pre>
github.update_pr_body 'Updated body'</pre>
</blockquote>

<blockquote>Close the pull request
  <pre>
github.close</pre>
</blockquote>

<blockquote>Open the pull request
  <pre>
github.open</pre>
</blockquote>





#### Methods

`mergeable?` - Whether mergeable and mergeable status is clean

`labels` - Get labels

`add_labels` - add labels to pull request

`remove_labels` - remove labels from pull request

`statuses` - get current commit statuses

`update_pr_title` - Update the title of the pull request

`update_pr_body` - Update the body of pull request

`close` - Close the pull request

`open` - Open the pull request




