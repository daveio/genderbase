require "simplecov"
SimpleCov.start "rails" do
  enable_coverage :branch

  # Add any custom groups or filters here
  add_group "Models", "app/models"
  add_group "Controllers", "app/controllers"
  add_group "Helpers", "app/helpers"
  add_group "Mailers", "app/mailers"
  add_group "Views", "app/views"

  # Don't include these directories in coverage reporting
  add_filter "/test/"
  add_filter "/config/"
  add_filter "/db/"
  add_filter "/vendor/"
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

# Module for controller tests that need authentication
module Devise::Test::ControllerHelpers
  # Sign in a responder for controller tests
  # @param responder [Responder] the responder to sign in (defaults to :one fixture)
  def sign_in_responder(responder = nil)
    @request.env["devise.mapping"] = Devise.mappings[:responder]
    responder ||= responders(:one)
    sign_in responder
  end
end

# Module for integration and system tests that need authentication
module AuthenticationHelper
  # Sign in a responder for integration or system tests
  # @param responder [Responder] the responder to sign in
  # @raise [ArgumentError] if responder is nil
  def sign_in_as(responder)
    raise ArgumentError, "Responder cannot be nil" if responder.nil?

    # For integration tests
    if respond_to?(:post)
      post responder_session_path, params: {
        responder: {
          email: responder.email,
          password: "password123"
        }
      }
      assert_response :redirect, "Login should redirect after successful authentication"
    # For system tests
    else
      visit new_responder_session_path

      # Verify we're on the login page
      assert_selector "h1", text: "Log in", wait: 5

      # Fill in the form
      within("#new_responder") do
        fill_in "Email", with: responder.email
        fill_in "Password", with: "password123"
        click_button "Log in"
      end

      # Wait for and verify successful login
      assert_selector ".notice",
                      text: "Signed in successfully.",
                      wait: 5,
                      message: "Login success message not found"
    end
  end
end

class ActionDispatch::IntegrationTest
  include AuthenticationHelper
end
