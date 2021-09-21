class GitHubService
  TURING_STAFF = %w(BrianZanti timomitchel scottalexandra jamisonordway)

  def initialize(repo_name)
    @repo_name = repo_name
  end

  def repo_names_and_commits
    names_and_commits
  end

  def repo_name
    repo_name_info
  end

  def pulls_count
    pulls_request_info.count do |pull|
      !TURING_STAFF.include?(pull[:user][:login])
    end
  end

  def commits_by_contributor
    contributor_commits.filter_map do |person|
      username = person[:author][:login]
      [username, person[:total]] unless TURING_STAFF.include?(username)
    end.to_h
  end

  def names_and_commits
    commits_by_contributor.map do |name, count|
      "#{name} with #{count} commits"
    end
  end

  private

  def contributor_commits
    @contributor_commits ||= GitHubClient.contribution_stats
  end

  def repo_name_info
    @repo_name ||= GitHubClient.repo_name
  end

  def pulls_request_info
    @pulls_count ||= GitHubClient.repo_pulls
  end
end
