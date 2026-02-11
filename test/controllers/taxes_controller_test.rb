require "test_helper"

class TaxesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
  end

  test "should get index" do
    get taxes_url
    assert_response :success
  end

  test "should create tax" do
    assert_difference("Tax.count") do
      post taxes_url, params: { tax: { amount: 100, date: Date.today, note: "Test tax" } }
    end
    assert_redirected_to taxes_path
  end

  test "should not create tax with invalid data" do
    assert_no_difference("Tax.count") do
      post taxes_url, params: { tax: { amount: 0, date: Date.today } }
    end
    assert_redirected_to taxes_path
  end

  test "redirects to login when not authenticated" do
    cookies[:session_id] = nil
    get taxes_url
    assert_redirected_to new_session_path
  end
end
