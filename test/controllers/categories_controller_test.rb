require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:alice)
  end

  test "should get index" do
    get categories_url
    assert_response :success
  end

  test "index shows only current household categories" do
    get categories_url
    # smith household has Groceries and Rent
    assert_select "span", text: "Groceries"
    assert_select "span", text: "Rent"
    # jones household Transport must not appear
    assert_select "span", { text: "Transport", count: 0 }
  end

  test "should get new" do
    get new_category_url
    assert_response :success
  end

  test "should create category in current household" do
    assert_difference("Category.count", 1) do
      post categories_url, params: { category: { name: "Dining" } }
    end
    assert_equal households(:smith), Category.order(:created_at).last.household
  end

  test "should get edit for own category" do
    get edit_category_url(categories(:groceries))
    assert_response :success
  end

  test "cannot edit another household's category" do
    get edit_category_url(categories(:transport))
    assert_response :not_found
  end

  test "cannot delete another household's category" do
    assert_no_difference("Category.count") do
      delete category_url(categories(:transport))
    end
    assert_response :not_found
  end

  test "should update own category" do
    patch category_url(categories(:groceries)), params: { category: { name: "Food & Groceries", monthly_budget: 400 } }
    assert_redirected_to categories_path
    assert_equal "Food & Groceries", categories(:groceries).reload.name
  end

  test "redirects to login when not authenticated" do
    cookies[:session_id] = nil
    get categories_url
    assert_redirected_to new_session_path
  end
end
