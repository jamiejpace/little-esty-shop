class BulkDiscountService
  class << self
    def next_three_holidays
      upcoming_holidays.slice(0,3)
    end

    def upcoming_holidays
      holiday_response = conn.get("/api/v2/NextPublicHolidays/US")
      json = JSON.parse(holiday_response.body, symbolize_names: true)
    end

    def conn
      conn = Faraday.new(url: "https://date.nager.at")
    end
  end
end
