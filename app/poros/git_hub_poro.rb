class GitHubPoro
  attr_reader :repo_name

  def initialize(params)
    @repo_name = params[:repo_name]
  end
end
