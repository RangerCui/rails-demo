# frozen_string_literal: true

#
# Annual summary job: Collects the summary data of all users in the previous year
#
class AnnualSummaryJob < ApplicationJob
  queue_as :low

  #
  # main method
  #
  def perform
    current_time = Time.now
    Account.find_each(batch_size: 1000) do |accounts|
      accounts.each do |account|
        monthly_summaries = account.monthly_summaries.where(year: current_time.year).select('amount, number_of_borrow')
        create_annual_summary_data(monthly_summaries, account, current_time)
      end
    end
  end

  #
  # Create annual statistics
  #
  # @param [Array][Object] monthly_summaries  Array of monthly_summaries object
  # @param [Object] account                   Account object
  # @param [Object] current_time              Time object
  #
  #
  def create_annual_summary_data(monthly_summaries, account, current_time)
    annual_summary_amount = monthly_summaries.sum(:amount_spent) rescue 0
    annual_summary_number = monthly_summaries.sum(:number_of_borrow) rescue 0
    AnnualSummary.create({
                           amount_spent: annual_summary_amount,
                           year: current_time.year,
                           number_of_borrow: annual_summary_number,
                           account_id: account.id
                         })
  end
end

