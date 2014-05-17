require 'test_helper'

class SupplyPurchasesControllerTest < ActionController::TestCase
  setup do
    @supply_purchase = supply_purchases(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:supply_purchases)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create supply_purchase" do
    assert_difference('SupplyPurchase.count') do
      post :create, supply_purchase: { comments: @supply_purchase.comments, currency_id: @supply_purchase.currency_id, provider_id: @supply_purchase.provider_id, total_paid: @supply_purchase.total_paid }
    end

    assert_redirected_to supply_purchase_path(assigns(:supply_purchase))
  end

  test "should show supply_purchase" do
    get :show, id: @supply_purchase
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @supply_purchase
    assert_response :success
  end

  test "should update supply_purchase" do
    patch :update, id: @supply_purchase, supply_purchase: { comments: @supply_purchase.comments, currency_id: @supply_purchase.currency_id, provider_id: @supply_purchase.provider_id, total_paid: @supply_purchase.total_paid }
    assert_redirected_to supply_purchase_path(assigns(:supply_purchase))
  end

  test "should destroy supply_purchase" do
    assert_difference('SupplyPurchase.count', -1) do
      delete :destroy, id: @supply_purchase
    end

    assert_redirected_to supply_purchases_path
  end
end
