class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user

  private

  def current_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  # def curate_names(contributors)
  #   all_contributors = contributors.map do |contrib|
  #     contrib[:login]
  #   end
  #   turing_staff = %w(BrianZanti timomitchel scottalexandra jamisonordway)
  #   all_contributors - turing_staff
  # end
  #
  # def sum_contributions(contributors)
  #   turing_staff = %w(BrianZanti timomitchel scottalexandra jamisonordway)
  #   commits = contributors.map do |contrib|
  #     if !turing_staff.include?(contrib[:login])
  #       contrib[:contributions]
  #     end
  #   end
  #   commits.compact.sum
  # end
end
