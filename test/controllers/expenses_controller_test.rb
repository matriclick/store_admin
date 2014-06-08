require 'test_helper'

class ExpensesControllerTest < ActionController::TestCase
  setup do
    @expense = expenses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:expenses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create expense" do
    assert_difference('Expense.count') do
      post :create, expense: { amount: @expense.amount, comments: @expense.comments, currency_id: @expense.currency_id, expense_type_id: @expense.expense_type_id, paid: @expense.paid, paid_by: @expense.paid_by, pay_date: @expense.pay_date }
    end

    assert_redirected_to expense_path(assigns(:expense))
  end

  test "should show expense" do
    get :show, id: @expense
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @expense
    assert_response :success
  end

  test "should update expense" do
    patch :update, id: @expense, expense: { amount: @expense.amount, comments: @expense.comments, currency_id: @expense.currency_id, expense_type_id: @expense.expense_type_id, paid: @expense.paid, paid_by: @expense.paid_by, pay_date: @expense.pay_date }
    assert_redirected_to expense_path(assigns(:expense))
  end

  test "should destroy expense" do
    assert_difference('Expense.count', -1) do
      delete :destroy, id: @expense
    end

    assert_redirected_to expenses_path
  end
end
