class ApplicationController < ActionController::Base
  # before_action :set_github_info, only: :index

  def set_github_info
    conn = Faraday.new('https://api.github.com')
    repo_response = conn.get('/repos/TannerDale/little-esty-shop')
    session[:repo] = JSON.parse(repo_response.body, symbolize_names: true)[:name]
    contrib_response = conn.get('https://api.github.com/repos/TannerDale/little-esty-shop/contributors')
    parsed_contributors = JSON.parse(contrib_response.body, symbolize_names: true)
    session[:user_names] = curate_names(parsed_contributors)
    session[:commits] = sum_contributions(parsed_contributors)
    # @pull_requests =
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
