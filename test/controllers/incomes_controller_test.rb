require "test_helper"

class IncomesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
  end

  test "should get index" do
    get incomes_url
    assert_response :success
    assert_select "h1", "Income"
  end

  test "index shows current month incomes" do
    get incomes_url
    assert_response :success
    assert_select "li", minimum: 1
  end

  test "should create income with valid params" do
    assert_difference("Income.count", 1) do
      post incomes_url, params: { income: { amount: 2000, date: Date.today, note: "Bonus" } }
    end
    assert_redirected_to incomes_path
  end

  test "should not create income without amount" do
    assert_no_difference("Income.count") do
      post incomes_url, params: { income: { amount: nil, date: Date.today } }
    end
    assert_redirected_to incomes_path
  end

  test "should not create income with negative amount" do
    assert_no_difference("Income.count") do
      post incomes_url, params: { income: { amount: -50, date: Date.today } }
    end
    assert_redirected_to incomes_path
  end

  test "should not create income without date" do
    assert_no_difference("Income.count") do
      post incomes_url, params: { income: { amount: 1000, date: nil } }
    end
    assert_redirected_to incomes_path
  end

  test "navigates to previous month" do
    prev = Date.today.beginning_of_month.prev_month
    get incomes_url(month: prev.month, year: prev.year)
    assert_response :success
    assert_select "span.font-semibold", prev.strftime("%B %Y")
  end

  test "navigates to next month" do
    nxt = Date.today.beginning_of_month.next_month
    get incomes_url(month: nxt.month, year: nxt.year)
    assert_response :success
    assert_select "span.font-semibold", nxt.strftime("%B %Y")
  end

  test "month navigation filters incomes" do
    prev = Date.today.beginning_of_month.prev_month
    get incomes_url(month: prev.month, year: prev.year)
    assert_response :success
    # Fixtures are in current month, so previous month should have none
    assert_select "div", text: "No income yet."
  end

  test "redirects to login when not authenticated" do
    cookies[:session_id] = nil
    get incomes_url
    assert_redirected_to new_session_path
  end
end
