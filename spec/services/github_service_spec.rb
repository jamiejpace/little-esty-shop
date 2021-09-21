require 'rails_helper'
require 'set'
#rspec spec/services/github_service_spec.rb
RSpec.describe 'github api' do
  describe 'repo name' do
    let(:github_response) { GitHubService.repo_info }

    it 'returns repo name' do
      github_response = {
        body: {name: 'little-esty-shop'}
      }
      stub_request(:get, "https://api.github.com/repos/tannerdale/little-esty-shop")
      .to_return(body: github_response.to_json)

      expect(github_response).to be_kind_of(Hash)
      expect(github_response).to have_key(:body)
      expect(github_response[:body][:name]).to eq('little-esty-shop')
    end
  end

  describe 'repo contributors' do
    let(:repo_contributors) { GitHubService.contribution_stats }

    it 'returns repo contributors' do
      contribution_stats = [
        {
          total: 10,
          author: {login: 'Lisa Miller'}
        },
        {
         total: 12,
         author: {login: 'Catherine Duke'}
        }
      ]

      stub_request(:get, "https://api.github.com/repos/tannerdale/little-esty-shop/stats/contributors")
      .to_return(body: contribution_stats.to_json)
      expected = {
         'Lisa Miller' => 10,
         'Catherine Duke' => 12
      }

      expect(repo_contributors).to be_kind_of(Set)
      expect(repo_contributors.length).to eq(2)
    end
  end



  describe 'repo pulls' do
    let(:repo_pulls) { GitHubService.repo_pulls }

    it 'returns repo pulls' do
      repo_pulls = {
        body: [{1 => 2}, {3 => 4}]
      }
      stub_request(:get, "https://api.github.com/repos/tannerdale/little-esty-shop/pulls?state=closed&per_page=100")
      .to_return(body: repo_pulls.to_json)

      expect(repo_pulls[:body]).to be_kind_of(Array)
      expect(repo_pulls[:body].length).to eq(2)
    end
  end

  describe 'helper methods' do
    let(:turing_staff) { %w(BrianZanti timomitchel scottalexandra jamisonordway) }
    it 'returns contributors names' do
      return_value = [
        {
          author: {login: 'cdelpone'},
          total: 38
        },
        {
          author: {login: 'tannerdale'},
          total: 75
        },
        {
          author: {login: 'jamisonordway'},
          total: 2
        }
      ]
      expected = {
        'cdelpone' => 38,
        'tannerdale' => 75
      }
      allow(GitHubService).to receive(:contribution_stats).and_return(return_value)

      expect(GitHubService.commits_by_contributor).to eq(expected)
    end

    it 'returns contributors names and commits' do
      return_value = {
        'cdelpone' => 38,
        'tannerdale' => 75
      }

      expected = ["cdelpone with 38 commits", "tannerdale with 75 commits"]

      allow(GitHubService).to receive(:commits_by_contributor).and_return(return_value)

      expect(GitHubService.names_and_commits).to eq(expected)
    end
  end
end
