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

  test "should update category with budget" do
    category = categories(:one)
    patch category_url(category), params: { category: { name: "Updated", monthly_budget: 300 } }
    assert_redirected_to categories_path
    category.reload
    assert_equal "Updated", category.name
    assert_equal 300, category.monthly_budget
  end

  test "should update category with nil budget" do
    category = categories(:one)
    category.update!(monthly_budget: 200)
    patch category_url(category), params: { category: { name: category.name, monthly_budget: "" } }
    assert_redirected_to categories_path
    category.reload
    assert_nil category.monthly_budget
  end

  test "redirects to login when not authenticated" do
    cookies[:session_id] = nil
    get categories_url
    assert_redirected_to new_session_path
  end
end
