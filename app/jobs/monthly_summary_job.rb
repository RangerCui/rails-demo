# frozen_string_literal: true

#
# monthly summary job: Collects the summary data of all users in the previous year
#
class MonthlySummaryJob < ApplicationJob
  queue_as :low

  #
  # main method
  #
  def perform
    current_time = Time.now
    start_of_time = current_time - 1.month
    Account.find_each(batch_size: 1000) do |accounts|
      accounts.each do |account|
        orders = account.orders.where('created_at between ? and ?', start_of_time, current_time).select('amount')
        create_monthly_summary_data(orders, account, current_time)
      end
    end
  end

  #
  # Create monthly statistics
  #
  # @param [Array][Object] orders  Array of order object
  # @param [Object] account        Account object
  # @param [Object] current_time   Time object
  #
  #
  def create_monthly_summary_data(orders, account, current_time)
    monthly_summary_amount = orders.sum(:amount) rescue 0
    monthly_summary_number = orders.size rescue 0
    MonthlySummary.create({
      amount_spent: monthly_summary_amount,
      month: current_time.month,
      year: current_time.year,
      number_of_borrow: monthly_summary_number,
      user_id: account.user_id
    })
  end
end
