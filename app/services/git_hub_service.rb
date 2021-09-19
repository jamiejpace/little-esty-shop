class GitHubService
  class << self
    def get_git_hub_info
      {
        repo_name: repo_info[:name]
      }
    end

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
  end
end
