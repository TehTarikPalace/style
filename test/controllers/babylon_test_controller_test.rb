require 'test_helper'

class BabylonTestControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
