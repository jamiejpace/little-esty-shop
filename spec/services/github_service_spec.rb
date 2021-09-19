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
    let(:repo_contributors) { GitHubService.contributor_names }

    it 'returns repo contributors' do
      repo_contributors = {
        body: ['Lisa Miller', 'Catherine Duke']
      }
      stub_request(:get, "https://api.github.com/repos/tannerdale/little-esty-shop/contributors")
      .to_return(body: repo_contributors.to_json)

      expect(repo_contributors[:body]).to be_kind_of(Array)
      expect(repo_contributors[:body]).to eq(['Lisa Miller', 'Catherine Duke'])
    end
  end

  describe 'repo commits' do
    let(:repo_commits) { GitHubService.repo_commits }

    it 'returns repo commits' do
      repo_commits = {
        body: Set.new([{
        "sha": "525d2eec8fa45eaed5ab62328d809b6bca05357c",
        "node_id": "MDY6Q29tbWl0NDA2MTI0MTY5OjUyNWQyZWVjOGZhNDVlYWVkNWFiNjIzMjhkODA5YjZiY2EwNTM1N2M=",
        "commit": {
            "author": {
                "name": "Christina Delpone",
                "email": "81711519+cdelpone@users.noreply.github.com",
                "date": "2021-09-18T22:00:41Z"
            },
            "committer": {
                "name": "GitHub",
                "email": "noreply@github.com",
                "date": "2021-09-18T22:00:41Z"
            },
            "message": "Merge pull request #79 from TannerDale/admin_stories\n\nThank you! This looks good."
            }
        }])
      }
      stub_request(:get, "https://api.github.com/repos/tannerdale/little-esty-shop/commits?author=cdelpone")
      .to_return(body: repo_commits.to_json)

      expect(repo_commits[:body]).to be_kind_of(Set)
      expect(repo_commits[:body].first[:commit].length).to eq(3)
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
        { login: 'cdelpone' },
        { login: 'tannerdale' },
        { login: 'jamisonordway' }
      ]

      allow(GitHubService).to receive(:repo_contributors).and_return(return_value)

      expect(GitHubService.contributor_names).to eq(['cdelpone', 'tannerdale'])
    end

    it 'returns contributors names and commits' do
      return_value = ['cdelpone', 'tannerdale']
      filtered = [
        { login: 'cdelpone' },
        { login: 'tannerdale' }
      ]
      expected = ["cdelpone with 2 commits", "tannerdale with 2 commits"]

      allow(GitHubService).to receive(:filter_results).and_return(filtered)
      allow(GitHubService).to receive(:contributor_names).and_return(return_value)

      expect(GitHubService.names_and_commits).to eq(expected)
    end

    it 'filters merge from results' do
    commits = Set.new([
        { commit: { message: 'Merge this' } },
        { commit: { message: 'Do that' } }
      ])

      allow(GitHubService).to receive(:repo_commits).and_return(commits)

      expect(GitHubService.filter_results('Keenan').length).to eq(1)
    end
  end
end
