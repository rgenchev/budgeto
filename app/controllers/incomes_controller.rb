class IncomesController < ApplicationController
  before_action :set_income, only: [:edit, :update, :destroy]

  def index
    if params[:month] && params[:year]
      @current_date = Date.new(params[:year].to_i, params[:month].to_i, 1)
    else
      @current_date = Date.today.beginning_of_month
    end

    range = @current_date.beginning_of_month..@current_date.end_of_month

    @income = Income.new(date: Date.today)

    @incomes = Income
      .where(date: range)
      .order(date: :desc, created_at: :desc)
  end

  def create
    @income = Income.new(income_params)

    if @income.save
      redirect_to incomes_path
    else
      redirect_to incomes_path, alert: @income.errors.full_messages.to_sentence
    end
  end

  def edit; end

  def update
    if @income.update(income_params)
      redirect_to incomes_path, notice: "Income updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @income.destroy
    redirect_to incomes_path, notice: "Income deleted"
  end

  private

  def set_income
    @income = Income.find(params[:id])
  end

  def income_params
    params.require(:income).permit(:amount, :date, :note)
  end
end
