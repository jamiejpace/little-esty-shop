class BulkDiscountFacade
  def self.holidays
    json = BulkDiscountService.next_three_holidays
    @holidays = json.map do |data|
      Holiday.new(data)
    end
  end
end
