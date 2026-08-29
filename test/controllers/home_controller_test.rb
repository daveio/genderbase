require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get home_index_url
    assert_response :success
  end

  test "should get about" do
    get home_about_url
    assert_response :success
  end

  test "should get team" do
    get home_team_url
    assert_response :success
  end

  test "should get privacy" do
    get home_privacy_url
    assert_response :success
  end

  test "should get volunteer" do
    get home_volunteer_url
    assert_response :success
  end

  test "should get security" do
    get home_security_url
    assert_response :success
  end

  test "should get support" do
    get home_support_url
    assert_response :success
  end

  test "should get donate" do
    get home_donate_url
    assert_response :success
  end

  test "should get good_faith" do
    get home_good_faith_url
    assert_response :success
  end
  test "index renders the hero, active navigation state and footer year" do
    get root_url
    assert_response :success
    assert_select "h1", /answered in good faith/
    assert_select "nav[aria-label=Primary] a[aria-current=page]", text: "Home"
    assert_select "footer", /© #{Date.current.year} Genderbase/
  end

  test "sub-pages render their hero through the shared partial and set the title" do
    get home_about_url
    assert_response :success
    assert_select "section.page-hero.page-hero-accent h1", text: "About Genderbase"
    assert_select "title", text: "About Genderbase · Genderbase"
  end

  test "flash notices render through the shared flash partial" do
    sign_in_as(responders(:one))
    get root_url
    assert_select ".alert.notice", text: "Signed in successfully."
  end
end
