require 'test_helper'

class StoreAdminControllerTest < ActionController::TestCase
  test "should get point_of_sale" do
    get :point_of_sale
    assert_response :success
  end

  test "should get products" do
    get :products
    assert_response :success
  end

  test "should get reports" do
    get :reports
    assert_response :success
  end

  test "should get users" do
    get :users
    assert_response :success
  end

  test "should get reports" do
    get :reports
    assert_response :success
  end

end
