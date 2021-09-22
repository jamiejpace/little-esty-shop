# frozen_string_literal: true
# require 'rails_helper'
#
# RSpec.describe 'GitHubService', type: :helper do
#   describe 'interface methods' do
#     let(:github) { GitHubService.new('little-esty-shop') }
#
#     # it 'has repo names and commits' do
#     #   return_value = ['cdelpone with 38 commits', 'TannerDale with 75 commits']
#     #   allow(GitHubClient).to receive(:names_and_commits).and_return(return_value)
#     #
#     #   expect(github.repo_names_and_commits).to eq(return_value)
#     # end
#
#     it 'has repo name' do
#       allow(GitHubClient).to receive(:repo_name).and_return('little-esty-shop')
#
#       expect(github.repo_name).to eq('little-esty-shop')
#     end
#
#     it 'has pulls count' do
#       expected = [
#         {user: {login: 'cdelpone'}},
#         {user: {login: 'TannerDale'}},
#         {user: {login: 'jamisonordway'}}
#       ]
#       allow(GitHubClient).to receive(:repo_pulls).and_return(expected)
# require "pry"; binding.pry
#       expect(github.pulls_count).to eq(2)
#     end
#   end
# describe 'helper methods' do
#   let(:turing_staff) { %w(BrianZanti timomitchel scottalexandra jamisonordway) }
#   it 'returns contributors names' do
#     return_value = [
#       {
#         author: {login: 'cdelpone'},
#         total: 38
#       },
#       {
#         author: {login: 'tannerdale'},
#         total: 75
#       },
#       {
#         author: {login: 'jamisonordway'},
#         total: 2
#       }
#     ]
#     expected = {
#       'cdelpone' => 38,
#       'tannerdale' => 75
#     }
#     allow(GitHubClient).to receive(:contribution_stats).and_return(return_value)

#     expect(GitHubClient.commits_by_contributor).to eq(expected)
#   end

#   it 'returns contributors names and commits' do
#     return_value = {
#       'cdelpone' => 38,
#       'tannerdale' => 75
#     }

#     expected = ["cdelpone with 38 commits", "tannerdale with 75 commits"]

#     allow(GitHubClient).to receive(:commits_by_contributor).and_return(return_value)

#     expect(GitHubClient.names_and_commits).to eq(expected)
#   end
# end
# end
