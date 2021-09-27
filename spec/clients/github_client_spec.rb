# frozen_string_literal: true

require 'rails_helper'
require 'set'
# rspec spec/services/github_service_spec.rb
RSpec.describe 'github api' do
  describe 'repo name' do
    let(:github_response) { GitHubClient.repo_info }

    it 'returns repo name' do
      github_response = {
        body: { name: 'little-esty-shop' }
      }
      stub_request(:get, 'https://api.github.com/repos/tannerdale/little-esty-shop')
        .to_return(body: github_response.to_json)

      expect(github_response).to be_kind_of(Hash)
      expect(github_response).to have_key(:body)
      expect(github_response[:body][:name]).to eq('little-esty-shop')
    end
  end

  # describe 'repo contributors' do
  #   let(:repo_contributors) { GitHubClient.contribution_stats }
  #
  #   it 'returns repo contributors' do
  #     contribution_stats = [
  #       {
  #         total: 10,
  #         author: { login: 'Lisa Miller' }
  #       },
  #       {
  #         total: 12,
  #         author: { login: 'Catherine Duke' }
  #       }
  #     ]
  #
  #     stub_request(:get, 'https://api.github.com/repos/tannerdale/little-esty-shop/stats/contributors')
  #       .to_return(body: contribution_stats.to_json)
  #
  #     expect(repo_contributors).to be_kind_of(Set)
  #     expect(repo_contributors.length).to eq(2)
  #   end
  # end

  describe 'repo pulls' do
    let(:repo_pulls) { GitHubClient.repo_pulls }

    it 'returns repo pulls' do
      repo_pulls = {
        body: [{ 1 => 2 }, { 3 => 4 }]
      }
      stub_request(:get, 'https://api.github.com/repos/tannerdale/little-esty-shop/pulls?state=closed&per_page=100')
        .to_return(body: repo_pulls.to_json)

      expect(repo_pulls[:body]).to be_kind_of(Array)
      expect(repo_pulls[:body].length).to eq(2)
    end
  end
end
