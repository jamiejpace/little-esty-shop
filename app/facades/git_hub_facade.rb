class GitHubFacade
  TURING_STAFF = %w(BrianZanti timomitchel scottalexandra jamisonordway)

  def initialize(repo_name)
    @repo_name = repo_name
  end

  def repo_names_and_commits
    contributor_info
  end

  def repo_name
    repo_name_info
  end

  def pulls_count
    pulls_request_info.count do |pull|
      !TURING_STAFF.include?(pull[:user][:login])
    end
  end

  private

  def contributor_info
    @contributor_info ||= GitHubService.names_and_commits
  end

  def repo_name_info
    @repo_name ||= GitHubService.repo_name
  end

  def pulls_request_info
    @pulls_count ||= GitHubService.repo_pulls
  end
end
