require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:alice)
  end

  test "should get index" do
    get root_url
    assert_response :success
    assert_select "h1", "Dashboard"
  end

  test "balance reflects only current household data" do
    household = households(:smith)
    range = Date.today.beginning_of_month..Date.today.end_of_month
    expected_balance = household.incomes.where(date: range).sum(:amount) -
                       household.taxes.where(date: range).sum(:amount) -
                       household.expenses.where(date: range).sum(:amount)

    get root_url
    assert_response :success
    formatted = ActionController::Base.helpers.number_to_currency(
      expected_balance, unit: "€", delimiter: ".", separator: ","
    )
    assert_select "div", text: /#{Regexp.escape(formatted)}/
  end

  test "spending by category shows only household categories" do
    get root_url
    assert_select "li", text: /Groceries/
    assert_select "li", text: /Rent/
    assert_select "li", { text: /Transport/, count: 0 }
  end

  test "displays green progress bar when under 80% of budget" do
    categories(:groceries).update!(monthly_budget: 200)
    get root_url
    assert_select ".bg-green-500", minimum: 1
  end

  test "displays orange progress bar when between 80-100% of budget" do
    categories(:groceries).update!(monthly_budget: 100) # 85.50/100 = 85%
    get root_url
    assert_select ".bg-orange-500", minimum: 1
  end

  test "displays red progress bar when over budget" do
    categories(:groceries).update!(monthly_budget: 50) # 85.50/50 = 171%
    get root_url
    assert_select ".bg-red-500", minimum: 1
  end

  test "navigates to previous month" do
    prev = Date.today.beginning_of_month.prev_month
    get dashboard_url(month: prev.month, year: prev.year)
    assert_response :success
  end

  test "redirects to login when not authenticated" do
    cookies[:session_id] = nil
    get root_url
    assert_redirected_to new_session_path
  end
end
