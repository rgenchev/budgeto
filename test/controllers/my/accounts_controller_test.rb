require "test_helper"

class My::AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:alice)
  end

  test "should get edit" do
    get edit_my_account_url
    assert_response :success
    assert_select "input[value='Alice']"
    assert_select "input[value='Smith']"
  end

  test "should update first and last name" do
    patch my_account_url, params: { user: { first_name: "Alicia", last_name: "Johnson" } }
    assert_redirected_to my_account_path
    users(:alice).reload
    assert_equal "Alicia", users(:alice).first_name
    assert_equal "Johnson", users(:alice).last_name
  end

  test "strips whitespace from names on update" do
    patch my_account_url, params: { user: { first_name: "  Alicia  ", last_name: "  Johnson  " } }
    users(:alice).reload
    assert_equal "Alicia", users(:alice).first_name
    assert_equal "Johnson", users(:alice).last_name
  end

  test "redirects to login when not authenticated" do
    cookies[:session_id] = nil
    get edit_my_account_url
    assert_redirected_to new_session_path
  end
end
