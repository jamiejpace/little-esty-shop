# frozen_string_literal: true

class GithubController < ApplicationController
  #
  # def set_github_info
  #   repo_response = Faraday.get('https://api.github.com/repos/TannerDale/little-esty-shop')
  #   @repository = JSON.parse(repo_response.body, symbolize_names: true)[:name]
  #   contrib_response = Faraday.get('https://api.github.com/repos/TannerDale/little-esty-shop/contributors')
  #   parsed_contributors = JSON.parse(contrib_response.body, symbolize_names: true)
  #   @user_names = curate_names(parsed_contributors)
  #   session[:commits] = sum_contributions(parsed_contributors)
  #   # @pull_requests =
  # end
  #
  # def curate_names(contributors)
  #   all_contributors = contributors.map do |contrib|
  #     contrib[:login]
  #   end
  #   turing_staff = %w(BrianZanti timomitchel scottalexandra jamisonordway)
  #   all_contributors - turing_staff
  # end
  #
  # def sum_contributions(contributors)
  #   turing_staff = %w(BrianZanti timomitchel scottalexandra jamisonordway)
  #   commits = contributors.map do |contrib|
  #     if !turing_staff.include(contrib[:login])
  #       contrib[:contributions]
  #     end
  #   end
  #   commits.compact.sum
  # end
end
