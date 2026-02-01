require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
  end

  test "should get index" do
    get categories_url
    assert_response :success
  end

  test "should get new" do
    get new_category_url
    assert_response :success
  end

  test "should get edit" do
    get edit_category_url(categories(:one))
    assert_response :success
  end

  test "redirects to login when not authenticated" do
    cookies[:session_id] = nil
    get categories_url
    assert_redirected_to new_session_path
  end
end
