class DashboardController < ApplicationController
  def index
    if params[:month] && params[:year]
      @current_date = Date.new(params[:year].to_i, params[:month].to_i, 1)
    else
      @current_date = Date.today.beginning_of_month
    end

    range = @current_date.beginning_of_month..@current_date.end_of_month
    household = Current.household

    @total_expenses = household.expenses.where(date: range).sum(:amount)
    @total_income   = household.incomes.where(date: range).sum(:amount)
    @total_taxes    = household.taxes.where(date: range).sum(:amount)
    @balance        = @total_income - @total_taxes - @total_expenses

    @by_category = household.expenses
      .joins(:category)
      .where(date: range)
      .group("categories.id", "categories.name", "categories.monthly_budget")
      .sum(:amount)
      .map { |(id, name, budget), spent| { name: name, spent: spent, budget: budget } }
      .sort_by { |c| -c[:spent] }

    @daily = household.expenses
      .where(date: range)
      .group(:date)
      .sum(:amount)
      .sort.reverse

    @monthly_expenses = household.expenses
      .where(date: 11.months.ago.beginning_of_month..Date.today.end_of_month)
      .group_by_month(:date, format: "%b %Y")
      .sum(:amount)
  end
end
