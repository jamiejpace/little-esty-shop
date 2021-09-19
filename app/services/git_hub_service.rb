class GitHubService
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

    def repo_contributors(repo_name)
      sleep 5
      response = conn.get('/repos/tannerdale/little-esty-shop/contributors')
      parse_data(response)
    end
  end
end
