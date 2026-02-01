require "test_helper"

class ExpensesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
  end

  test "should get index" do
    get expenses_url
    assert_response :success
    assert_select "h1", "Expenses"
  end

  test "index shows current month expenses" do
    get expenses_url
    assert_response :success
    assert_select "li", minimum: 1
  end

  test "should create expense with valid params" do
    assert_difference("Expense.count", 1) do
      post expenses_url, params: { expense: { amount: 25.50, date: Date.today, note: "Lunch", category_id: categories(:one).id } }
    end
    assert_redirected_to expenses_path
  end

  test "should not create expense without amount" do
    assert_no_difference("Expense.count") do
      post expenses_url, params: { expense: { amount: nil, date: Date.today, category_id: categories(:one).id } }
    end
    assert_redirected_to expenses_path
  end

  test "navigates to previous month" do
    prev = Date.today.beginning_of_month.prev_month
    get expenses_url(month: prev.month, year: prev.year)
    assert_response :success
    assert_select "span.font-semibold", prev.strftime("%B %Y")
  end

  test "navigates to next month" do
    nxt = Date.today.beginning_of_month.next_month
    get expenses_url(month: nxt.month, year: nxt.year)
    assert_response :success
    assert_select "span.font-semibold", nxt.strftime("%B %Y")
  end

  test "month navigation filters expenses" do
    prev = Date.today.beginning_of_month.prev_month
    get expenses_url(month: prev.month, year: prev.year)
    assert_response :success
    # Fixtures are in current month, so previous month should have none
    assert_select "div", text: "No expenses yet."
  end

  test "filter by category returns only that category's expenses" do
    food = categories(:one)
    get expenses_url(category: food.id)
    assert_response :success
    assert_select "li", count: 1
    assert_select "li div div.font-medium", text: "Food"
  end

  test "filter by category persists across month navigation" do
    food = categories(:one)
    get expenses_url(category: food.id)
    assert_response :success
    # Check that prev/next month links include the category param
    assert_select "a[href*='category=#{food.id}']", minimum: 2
  end

  test "redirects to login when not authenticated" do
    cookies[:session_id] = nil
    get expenses_url
    assert_redirected_to new_session_path
  end
end
