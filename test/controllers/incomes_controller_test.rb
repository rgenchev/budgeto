require "test_helper"

class IncomesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:alice)
  end

  test "should get index" do
    get incomes_url
    assert_response :success
    assert_select "h1", "Income"
  end

  test "index shows only current household incomes" do
    get incomes_url
    assert_select "li", count: 1
    assert_select "li", text: /Monthly salary/
  end

  test "should create income and assign current user and household" do
    assert_difference("Income.count", 1) do
      post incomes_url, params: { income: { amount: 500, date: Date.today, note: "Freelance" } }
    end
    created = Income.order(:created_at).last
    assert_equal users(:alice), created.user
    assert_equal households(:smith), created.household
  end

  test "should not create income without amount" do
    assert_no_difference("Income.count") do
      post incomes_url, params: { income: { amount: nil, date: Date.today } }
    end
  end

  test "should get edit for own income" do
    get edit_income_url(incomes(:alice_salary))
    assert_response :success
  end

  test "cannot edit another household's income" do
    get edit_income_url(incomes(:carol_salary))
    assert_response :not_found
  end

  test "cannot delete another household's income" do
    assert_no_difference("Income.count") do
      delete income_url(incomes(:carol_salary))
    end
    assert_response :not_found
  end

  test "should update own income" do
    patch income_url(incomes(:alice_salary)), params: { income: { amount: 4000 } }
    assert_redirected_to incomes_path
    assert_equal 4000, incomes(:alice_salary).reload.amount.to_f
  end

  test "should destroy own income" do
    assert_difference("Income.count", -1) do
      delete income_url(incomes(:alice_salary))
    end
    assert_redirected_to incomes_path
  end

  test "redirects to login when not authenticated" do
    cookies[:session_id] = nil
    get incomes_url
    assert_redirected_to new_session_path
  end
end
