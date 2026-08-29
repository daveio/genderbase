require "test_helper"

class QuestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @question = questions(:one)
    @responder = responders(:one)
  end

  test "should get index" do
    sign_in_as(@responder)
    get questions_url
    assert_response :success
  end

  test "should get new" do
    sign_in_as(@responder)
    get new_question_url
    assert_response :success
  end

  test "should create question" do
    sign_in_as(@responder)
    assert_difference("Question.count") do
      post questions_url, params: { question: { body: @question.body, email: @question.email, responder_id: @question.responder_id, status: @question.status, title: @question.title, token: @question.token } }
    end

    assert_redirected_to question_token_url(token: Question.last.token)

    follow_redirect!
    assert_select ".alert.notice", text: /successfully created/
  end

  test "should show question" do
    sign_in_as(@responder)
    get question_url(@question)
    assert_response :success
  end

  test "should get edit" do
    sign_in_as(@responder)
    get edit_question_url(@question)
    assert_response :success
  end

  test "should update question" do
    sign_in_as(@responder)
    patch question_url(@question), params: { question: { body: @question.body, email: @question.email, responder_id: @question.responder_id, status: @question.status, title: @question.title, token: @question.token } }
    assert_redirected_to question_url(@question)
  end

  test "should destroy question" do
    sign_in_as(@responder)
    assert_difference("Question.count", -1) do
      delete question_url(@question)
    end

    assert_redirected_to questions_url
  end
end
