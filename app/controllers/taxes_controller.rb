class TaxesController < ApplicationController
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

  private

  def tax_params
    params.require(:tax).permit(:amount, :date, :note)
  end
end
