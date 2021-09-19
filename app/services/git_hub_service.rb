require 'set'

class GitHubService
  TURING_STAFF = %w(BrianZanti timomitchel scottalexandra jamisonordway)
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

    def repo_contributors
      sleep 5
      response = conn.get('/repos/tannerdale/little-esty-shop/contributors')
      parse_data(response)
    end

    def contributor_names
      all_contribs = repo_contributors.map do |contrib|
        contrib[:login]
      end
      all_contribs - TURING_STAFF
    end

    def names_and_commits
      contributor_names.map do |name|
        count = filter_results(name).length
        "#{name} with #{count} commits"
      end
    end

    def repo_commits(name)
      response = conn.get("/repos/tannerdale/little-esty-shop/commits?author=#{name}&per_page=100&page_count=2")
      Set.new(parse_data(response))
    end

    def filter_results(name)
      repo_commits(name).delete_if do |result|
        result[:commit][:message].start_with?("Merge")
      end
    end

    def repo_pulls
      #need to account for second page of results
      response = conn.get('/repos/tannerdale/little-esty-shop/pulls?state=closed&per_page=100')
      parse_data(response)
    end
  end
end
