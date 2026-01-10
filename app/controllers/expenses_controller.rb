# app/controllers/expenses_controller.rb
class ExpensesController < ApplicationController
  def index
    @expense = Expense.new(date: Date.today)

    @expenses = Expense
      .includes(:category)
      .where(date: Date.today.beginning_of_month..Date.today.end_of_month)
      .order(date: :desc, created_at: :desc)
  end

  def create
    @expense = Expense.new(expense_params)

    if @expense.save
      redirect_to expenses_path
    else
      @expenses = Expense
        .includes(:category)
        .where(date: Date.today.beginning_of_month..Date.today.end_of_month)
        .order(date: :desc)

      redirect_to expenses_path, alert: @expense.errors.full_messages.to_sentence
    end
  end

  private

  def expense_params
    params.require(:expense).permit(:amount, :date, :note, :category_id)
  end
end
