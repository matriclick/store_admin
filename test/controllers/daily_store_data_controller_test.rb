require 'test_helper'

class DailyStoreDataControllerTest < ActionController::TestCase
  setup do
    @daily_store_datum = daily_store_data(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:daily_store_data)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create daily_store_datum" do
    assert_difference('DailyStoreDatum.count') do
      post :create, daily_store_datum: { came_in_clients: @daily_store_datum.came_in_clients, date: @daily_store_datum.date, supplier_account_id: @daily_store_datum.supplier_account_id }
    end

    assert_redirected_to daily_store_datum_path(assigns(:daily_store_datum))
  end

  test "should show daily_store_datum" do
    get :show, id: @daily_store_datum
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @daily_store_datum
    assert_response :success
  end

  test "should update daily_store_datum" do
    patch :update, id: @daily_store_datum, daily_store_datum: { came_in_clients: @daily_store_datum.came_in_clients, date: @daily_store_datum.date, supplier_account_id: @daily_store_datum.supplier_account_id }
    assert_redirected_to daily_store_datum_path(assigns(:daily_store_datum))
  end

  test "should destroy daily_store_datum" do
    assert_difference('DailyStoreDatum.count', -1) do
      delete :destroy, id: @daily_store_datum
    end

    assert_redirected_to daily_store_data_path
  end
end
