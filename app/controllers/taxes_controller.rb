class TaxesController < ApplicationController
  before_action :set_tax, only: [:edit, :update, :destroy]

  def index
    if params[:month] && params[:year]
      @current_date = Date.new(params[:year].to_i, params[:month].to_i, 1)
    else
      @current_date = Date.today.beginning_of_month
    end

    range = @current_date.beginning_of_month..@current_date.end_of_month

    @tax = Tax.new(date: Date.today)

    @taxes = Tax
      .where(date: range)
      .order(date: :desc, created_at: :desc)
  end

  def create
    @tax = Tax.new(tax_params)

    if @tax.save
      redirect_to taxes_path
    else
      redirect_to taxes_path, alert: @tax.errors.full_messages.to_sentence
    end
  end

  def edit; end

  def update
    if @tax.update(tax_params)
      redirect_to taxes_path, notice: "Tax updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @tax.destroy
    redirect_to taxes_path, notice: "Tax deleted"
  end

  private

  def set_tax
    @tax = Tax.find(params[:id])
  end

  def tax_params
    params.require(:tax).permit(:amount, :date, :note)
  end
end
