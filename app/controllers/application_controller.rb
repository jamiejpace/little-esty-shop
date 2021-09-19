class ApplicationController < ActionController::Base
  # before_action :set_github_info, only: :index

  def self.set_github_info
    git_hub_info = GitHubFacade.fetch_git_hub_info
    require 'pry'; binding.pry
    # conn = Faraday.new('https://api.github.com')
    # repo_response = conn.get('/repos/TannerDale/little-esty-shop')
    # repo_response = Faraday.get('https://api.github.com/repos/tannerdale/little-esty-shop')
    # parsed_repo = parse(repo_response)
    # session[:repo] = parsed_repo[:name]
    #
    # contrib_response = conn.get('/repos/TannerDale/little-esty-shop/contributors')
    # parsed_contributors = parse(contrib_response)
    # session[:user_names] = curate_names(parsed_contributors)
    # session[:commits] = sum_contributions(parsed_contributors)
    #
    # pulls_response = conn.get('/repos/TannerDale/little-esty-shop/pulls?state=closed&per_page=100')
    # parsed_pulls = parse(pulls_response)
    # session[:pulls_count] = parsed_pulls.count
  end

  def self.parse(response)
    JSON.parse(response.body, symbolize_names: true)
  end

  def curate_names(contributors)
    all_contributors = contributors.map do |contrib|
      contrib[:login]
    end
    turing_staff = %w(BrianZanti timomitchel scottalexandra jamisonordway)
    all_contributors - turing_staff
  end

  def sum_contributions(contributors)
    turing_staff = %w(BrianZanti timomitchel scottalexandra jamisonordway)
    commits = contributors.map do |contrib|
      if !turing_staff.include?(contrib[:login])
        contrib[:contributions]
      end
    end
    commits.compact.sum
  end
end
