class GitHubFacade
  def  fetch_git_hub_info
    git_hub_info = GitHubService.get_git_hub_info
    GitHubPoro.new(git_hub_info)
  end

  def initialize(repo_name)
    @repo_name = repo_name
  end

  def contributor_names
    contributor_info.filter_map do |contrib|
      contrib[:login] unless turing_staff.include?(contrib[:login])
    end
  end

  def contribution_count
    contributor_info.sum do |contrib|
      contrib[:contributions]
    end
  end

  def repo_name
    repo_name_info
  end

  private

  def contributor_info
    @contributor_info ||= GitHubService.repo_contributors(@repo_name)
  end

  def repo_name_info
    @repo_name ||= GitHubService.repo_name(@repo_name)
  end

  def pull_request_info
    @pull_count ||= GitHubService.pull_count(@repo_name)
  end
end
