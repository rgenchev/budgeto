require "test_helper"

class ExpensesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:alice)
  end

  test "should get index" do
    get expenses_url
    assert_response :success
    assert_select "h1", "Expenses"
  end

  test "index shows only current household expenses" do
    get expenses_url
    assert_response :success
    # alice_groceries and alice_rent belong to smith household — both visible
    assert_select "li", minimum: 2
    # carol's transport expense (jones household) must not appear
    assert_select "li div div.font-medium", { text: "Transport", count: 0 }
  end

  test "should create expense and assign current user and household" do
    assert_difference("Expense.count", 1) do
      post expenses_url, params: {
        expense: { amount: 25.50, date: Date.today, note: "Lunch", category_id: categories(:groceries).id }
      }
    end
    created = Expense.order(:created_at).last
    assert_equal users(:alice), created.user
    assert_equal households(:smith), created.household
  end

  test "redirect after create preserves month and year params" do
    prev = Date.today.beginning_of_month.prev_month
    post expenses_url(month: prev.month, year: prev.year), params: {
      expense: { amount: 10, date: prev, category_id: categories(:groceries).id },
      month: prev.month,
      year: prev.year
    }
    assert_redirected_to expenses_path(month: prev.month, year: prev.year)
  end

  test "should not create expense without amount" do
    assert_no_difference("Expense.count") do
      post expenses_url, params: { expense: { amount: nil, date: Date.today, category_id: categories(:groceries).id } }
    end
    assert_redirected_to expenses_path
  end

  test "filter by category shows only that category expenses" do
    get expenses_url(category: categories(:groceries).id)
    assert_response :success
    assert_select "li", count: 1
    assert_select "li div div.font-medium", text: "Groceries"
  end

  test "navigates to previous month" do
    prev = Date.today.beginning_of_month.prev_month
    get expenses_url(month: prev.month, year: prev.year)
    assert_response :success
    assert_select "span.font-semibold", prev.strftime("%B %Y")
  end

  test "month navigation shows no expenses for empty month" do
    prev = Date.today.beginning_of_month.prev_month
    get expenses_url(month: prev.month, year: prev.year)
    assert_response :success
    assert_select "div", text: "No expenses yet."
  end

  test "should get edit for own expense" do
    get edit_expense_url(expenses(:alice_groceries))
    assert_response :success
  end

  test "cannot edit another household's expense" do
    get edit_expense_url(expenses(:carol_transport))
    assert_response :not_found
  end

  test "cannot delete another household's expense" do
    assert_no_difference("Expense.count") do
      delete expense_url(expenses(:carol_transport))
    end
    assert_response :not_found
  end

  test "should update own expense" do
    expense = expenses(:alice_groceries)
    patch expense_url(expense), params: { expense: { amount: 99.99 } }
    assert_redirected_to expenses_path
    assert_equal 99.99, expense.reload.amount.to_f
  end

  test "should destroy own expense" do
    assert_difference("Expense.count", -1) do
      delete expense_url(expenses(:alice_groceries))
    end
    assert_redirected_to expenses_path
  end

  test "redirects to login when not authenticated" do
    cookies[:session_id] = nil
    get expenses_url
    assert_redirected_to new_session_path
  end
end
