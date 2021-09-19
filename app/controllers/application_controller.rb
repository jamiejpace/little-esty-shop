class ApplicationController < ActionController::Base
  
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
