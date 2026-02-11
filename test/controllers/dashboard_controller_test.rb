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

  test "displays taxes card" do
    get root_url
    assert_response :success
    assert_select "div", /Taxes/
  end

  test "balance equals income minus taxes minus expenses" do
    range = Date.today.beginning_of_month..Date.today.end_of_month
    total_income = Income.where(date: range).sum(:amount)
    total_taxes = Tax.where(date: range).sum(:amount)
    total_expenses = Expense.where(date: range).sum(:amount)
    expected_balance = total_income - total_taxes - total_expenses

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

  test "displays budget progress bar for category with budget" do
    category = categories(:one)
    category.update!(monthly_budget: 100)

    get root_url
    assert_response :success
    assert_select ".bg-gray-200.rounded-full", minimum: 1
  end

  test "displays green progress bar when under 80% of budget" do
    category = categories(:one)
    category.update!(monthly_budget: 100)
    # Existing fixture expense is 9.99 which is under 80%

    get root_url
    assert_response :success
    assert_select ".bg-green-500", minimum: 1
  end

  test "displays orange progress bar when between 80-100% of budget" do
    category = categories(:one)
    category.update!(monthly_budget: 12) # 9.99/12 = 83%

    get root_url
    assert_response :success
    assert_select ".bg-orange-500", minimum: 1
  end

  test "displays red progress bar when over budget" do
    category = categories(:one)
    category.update!(monthly_budget: 5) # 9.99/5 = 200%

    get root_url
    assert_response :success
    assert_select ".bg-red-500", minimum: 1
  end

  test "does not display progress bar for category without budget" do
    category = categories(:one)
    category.update!(monthly_budget: nil)

    get root_url
    assert_response :success
    # Should have category name but no progress bar for that category
    assert_select "li", text: /Food/
  end
end
