# frozen_string_literal: true

require 'set'

class GitHubClient
  class << self
    def repo_info
      response = conn.get('/repos/tannerdale/little-esty-shop')
      parse_data(response)
    end

    def conn
      Faraday.new('https://api.github.com')
    end

    def parse_data(response)
      JSON.parse(response.body, symbolize_names: true)
    end

    def repo_name
      response = conn.get('/repos/tannerdale/little-esty-shop')
      parse_data(response)[:name]
    end

    def contribution_stats
      response = conn.get('/repos/tannerdale/little-esty-shop/stats/contributors')
      Set.new(parse_data(response))
    end

    def repo_pulls
      response = conn.get('/repos/tannerdale/little-esty-shop/pulls?state=closed&per_page=100')
      parse_data(response)
    end
  end
end
