class GitHubFacade
  class << self
    def  fetch_git_hub_info
      git_hub_info = GitHubService.get_git_hub_info
      GitHubPoro.new(git_hub_info)
    end
  end
end
