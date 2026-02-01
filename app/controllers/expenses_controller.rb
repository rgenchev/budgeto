# app/controllers/expenses_controller.rb
class ExpensesController < ApplicationController
  def index
    if params[:month] && params[:year]
      @current_date = Date.new(params[:year].to_i, params[:month].to_i, 1)
    else
      @current_date = Date.today.beginning_of_month
    end

    range = @current_date.beginning_of_month..@current_date.end_of_month

    @expense = Expense.new(date: Date.today)
    @categories = Category.order(:name)

    @expenses = Expense
      .includes(:category)
      .where(date: range)
      .order(date: :desc, created_at: :desc)

    if params[:category].present?
      @current_category = Category.find_by(id: params[:category])
      @expenses = @expenses.where(category_id: @current_category.id) if @current_category
    end
  end

  def create
    @expense = Expense.new(expense_params)

    if @expense.save
      redirect_to expenses_path
    else
      redirect_to expenses_path, alert: @expense.errors.full_messages.to_sentence
    end
  end

  private

  def expense_params
    params.require(:expense).permit(:amount, :date, :note, :category_id)
  end
end
