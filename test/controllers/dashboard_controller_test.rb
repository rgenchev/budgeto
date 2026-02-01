require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
  end

  test "should get index" do
    get root_url
    assert_response :success
    assert_select "h1", "Dashboard"
  end

  test "displays income card" do
    get root_url
    assert_select ".text-green-600", minimum: 1
  end

  test "displays expenses card" do
    get root_url
    assert_response :success
    assert_select "div", /Expenses/
  end

  test "displays balance card" do
    get root_url
    assert_response :success
    assert_select "div", /Balance/
  end

  test "balance equals income minus expenses" do
    range = Date.today.beginning_of_month..Date.today.end_of_month
    total_income = Income.where(date: range).sum(:amount)
    total_expenses = Expense.where(date: range).sum(:amount)
    expected_balance = total_income - total_expenses

    get root_url
    assert_response :success

    assert_select "div", text: /#{Regexp.escape(ActionController::Base.helpers.number_to_currency(expected_balance, unit: "€", delimiter: ".", separator: ","))}/
  end

  test "navigates to previous month" do
    prev = Date.today.beginning_of_month.prev_month
    get dashboard_url(month: prev.month, year: prev.year)
    assert_response :success
  end

  test "navigates to next month" do
    nxt = Date.today.beginning_of_month.next_month
    get dashboard_url(month: nxt.month, year: nxt.year)
    assert_response :success
  end

  test "redirects to login when not authenticated" do
    cookies[:session_id] = nil
    get root_url
    assert_redirected_to new_session_path
  end
end
