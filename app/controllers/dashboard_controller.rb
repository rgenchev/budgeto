# app/controllers/dashboard_controller.rb
class DashboardController < ApplicationController
  def index
    # Determine which month/year to show
    if params[:month] && params[:year]
      month = params[:month].to_i
      year = params[:year].to_i
      @current_date = Date.new(year, month, 1)
    else
      @current_date = Date.today.beginning_of_month
    end

    range = @current_date.beginning_of_month..@current_date.end_of_month

    @total_this_month = Expense.where(date: range).sum(:amount)

    @by_category = Expense
      .joins(:category)
      .where(date: range)
      .group("categories.name")
      .sum(:amount)
      .sort_by { |_k, v| -v }

    @daily = Expense
      .where(date: range)
      .group(:date)
      .sum(:amount)
      .sort.reverse

    # Monthly totals for the year of the current month
    year_range = @current_date.beginning_of_year..@current_date.end_of_year

    @monthly_totals = Expense
      .where(date: year_range)
      .group_by_month(:date, format: "%b")
      .sum(:amount)
  end
end
