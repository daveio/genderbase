require "test_helper"

class DeviseViewsTest < ActionDispatch::IntegrationTest
  test "log in page renders the styled form with the shared links" do
    get new_responder_session_url

    assert_response :success
    assert_select "title", text: "Log in · Genderbase"
    assert_select "h1", text: "Log in"
    assert_select "form#new_responder input.input[type=email][name='responder[email]']"
    assert_select "form#new_responder input.input[type=password][name='responder[password]']"
    assert_select "form#new_responder input.checkbox[name='responder[remember_me]']"
    assert_select "form#new_responder input[type=submit].btn.btn-primary[value='Log in']"
    assert_select "nav[aria-label=Account] a.link-quiet[href=?]", new_responder_password_path, text: "Forgot your password?"
    assert_select "nav[aria-label=Account] a.link-quiet[href=?]", new_responder_registration_path, text: "Sign up"
  end

  test "failed log in shows the alert through the shared flash partial" do
    post responder_session_url, params: { responder: { email: "nobody@example.com", password: "wrong" } }

    assert_response :unprocessable_entity
    assert_select ".alert.alert-error", text: /Invalid email or password/i
    assert_select "h1", text: "Log in"
  end

  test "forgot password page renders" do
    get new_responder_password_url

    assert_response :success
    assert_select "h1", text: "Forgot your password?"
    assert_select "form#new_responder input.input[type=email]"
    assert_select "form#new_responder input[type=submit][value='Email me a reset link']"
    assert_select "nav[aria-label=Account] a[href=?]", new_responder_session_path, text: "Log in"
  end

  test "reset password page renders with the token field" do
    get edit_responder_password_url(reset_password_token: "not-a-real-token")

    assert_response :success
    assert_select "h1", text: "Choose a new password"
    assert_select "input[type=hidden][name='responder[reset_password_token]'][value='not-a-real-token']"
    assert_select "form input.input[type=password][name='responder[password]']"
  end

  test "sign up page renders and shows validation errors in an alert" do
    get new_responder_registration_url

    assert_response :success
    assert_select "h1", text: "Sign up"

    post responder_registration_url, params: { responder: { email: "", password: "short", password_confirmation: "different" } }

    assert_response :unprocessable_entity
    assert_select "#error_explanation.alert.alert-error"
    assert_select "#error_explanation li", minimum: 2
  end

  test "account settings page renders for a signed-in responder" do
    sign_in_as(responders(:one))
    get edit_responder_registration_url

    assert_response :success
    assert_select "h1", text: "Account settings"
    assert_select "form#edit_responder input.input[type=password][name='responder[current_password]']"
    assert_select "form#edit_responder input[type=submit][value='Save changes']"
    assert_select "h2", text: "Delete account"
    assert_select "form[action=?] input[type=hidden][name=_method][value=delete]", responder_registration_path
    assert_select "form[action=?] button.btn-error", responder_registration_path, text: "Delete my account"
  end
end
