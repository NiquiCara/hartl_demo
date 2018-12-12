require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:michael)
	end
		
  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)

    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url

    # Simulate a user clicking logout in a second window.
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  # test "login with remembering" do
   # log_in_as(@user, remember_me: '1')
   # assert_equal @user.name, assigns(:user).name
  # end

  test "login without remembering" do
    # Log in to set the cookie.
    log_in_as(@user, remember_me: '1')
    # Log in again and verify that the cookie is deleted.
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end

=begin
  # another possible test to try
  test "logging in with remembering will persist a login across sessions" do
    # log in as @user, remember_me: '1'
    # visit a protected area and ensure that it's successful
    # destroy the session
    # visit the protected area again and ensure that it's successful

    # log in as @user, remember_me: '0'
    # visit proteted area and ensure that it's successful
    # destroy the session
    # visit the protected area again and ensure it's NOT successful
  end
=end  
end