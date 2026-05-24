require "test_helper"

class TaxesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:alice)
  end

  test "should get index" do
    get taxes_url
    assert_response :success
  end

  test "index shows only current household taxes" do
    get taxes_url
    assert_select "li", count: 1
    assert_select "li", text: /Income tax/
  end

  test "should create tax and assign current user and household" do
    assert_difference("Tax.count", 1) do
      post taxes_url, params: { tax: { amount: 100, date: Date.today, note: "VAT" } }
    end
    created = Tax.order(:created_at).last
    assert_equal users(:alice), created.user
    assert_equal households(:smith), created.household
  end

  test "should not create tax with invalid data" do
    assert_no_difference("Tax.count") do
      post taxes_url, params: { tax: { amount: 0, date: Date.today } }
    end
  end

  test "should get edit for own tax" do
    get edit_tax_url(taxes(:alice_income_tax))
    assert_response :success
  end

  test "cannot edit another household's tax" do
    get edit_tax_url(taxes(:carol_income_tax))
    assert_response :not_found
  end

  test "cannot delete another household's tax" do
    assert_no_difference("Tax.count") do
      delete tax_url(taxes(:carol_income_tax))
    end
    assert_response :not_found
  end

  test "should update own tax" do
    patch tax_url(taxes(:alice_income_tax)), params: { tax: { amount: 800 } }
    assert_redirected_to taxes_path
    assert_equal 800, taxes(:alice_income_tax).reload.amount.to_f
  end

  test "should destroy own tax" do
    assert_difference("Tax.count", -1) do
      delete tax_url(taxes(:alice_income_tax))
    end
    assert_redirected_to taxes_path
  end

  test "redirects to login when not authenticated" do
    cookies[:session_id] = nil
    get taxes_url
    assert_redirected_to new_session_path
  end
end
