require 'rails_helper'

RSpec.describe 'github api' do
  describe 'repo response' do
    let(:github_response) { GitHubService.repo_info }

    it 'returns data' do
      expect(github_response).to be_kind_of(Hash)
      expect(github_response).to have_key(:body)
      expect(github_response[:body][:name]).to eq('little-esty-shop')
    end
  end
end
