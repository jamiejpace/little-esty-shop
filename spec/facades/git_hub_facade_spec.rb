# require 'rails_helper'
#
# RSpec.describe 'GitHubFacade', type: :helper do
#   describe 'interface methods' do
#     let(:github) { GitHubFacade.new('little-esty-shop') }
#
#     it 'has repo names and commits' do
#       return_value = ['cdelpone with 38 commits', 'TannerDale with 75 commits']
#       allow(GitHubService).to receive(:names_and_commits).and_return(return_value)
#
#       expect(github.repo_names_and_commits).to eq(return_value)
#     end
#
#     it 'has repo name' do
#       allow(GitHubService).to receive(:repo_name).and_return('little-esty-shop')
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
#       allow(GitHubService).to receive(:repo_pulls).and_return(expected)
# require "pry"; binding.pry
#       expect(github.pulls_count).to eq(2)
#     end
#   end
# end
