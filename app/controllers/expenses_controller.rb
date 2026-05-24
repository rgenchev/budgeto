class ExpensesController < ApplicationController
  before_action :set_expense, only: [:edit, :update, :destroy]

  def index
    if params[:month] && params[:year]
      @current_date = Date.new(params[:year].to_i, params[:month].to_i, 1)
    else
      @current_date = Date.today.beginning_of_month
    end

    range = @current_date.beginning_of_month..@current_date.end_of_month

    default_date = if @current_date.month == Date.today.month && @current_date.year == Date.today.year
      Date.today
    else
      Current.household.expenses.where(date: range).maximum(:date) || @current_date.beginning_of_month
    end

    @expense = Expense.new(date: default_date)
    @categories = Current.household.categories.order(:name)

    @expenses = Current.household.expenses
      .includes(:category, :user)
      .where(date: range)
      .order(date: :desc, created_at: :desc)

    if params[:category].present?
      @current_category = @categories.find_by(id: params[:category])
      @expenses = @expenses.where(category_id: @current_category.id) if @current_category
    end
  end

  def create
    @expense = Current.household.expenses.build(expense_params)
    @expense.user = Current.user

    if @expense.save
      redirect_to expenses_path(month: params[:month], year: params[:year])
    else
      redirect_to expenses_path(month: params[:month], year: params[:year]), alert: @expense.errors.full_messages.to_sentence
    end
  end

  def edit
    @categories = Current.household.categories.order(:name)
  end

  def update
    if @expense.update(expense_params)
      redirect_to expenses_path, notice: "Expense updated"
    else
      @categories = Current.household.categories.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy
    redirect_to expenses_path, notice: "Expense deleted"
  end

  private

  def set_expense
    @expense = Current.household.expenses.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(:amount, :date, :note, :category_id)
  end
end
