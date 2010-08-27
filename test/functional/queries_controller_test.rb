require 'test_helper'

class QueriesControllerTest < ActionController::TestCase
  context "index action" do
    should "render index template" do
      get :index
      assert_template 'index'
    end
  end
  
  context "show action" do
    should "render show template" do
      get :show, :id => Query.first
      assert_template 'show'
    end
  end
  
  context "new action" do
    should "render new template" do
      get :new
      assert_template 'new'
    end
  end
  
  context "create action" do
    should "render new template when model is invalid" do
      Query.any_instance.stubs(:valid?).returns(false)
      post :create
      assert_template 'new'
    end
    
    should "redirect when model is valid" do
      Query.any_instance.stubs(:valid?).returns(true)
      post :create
      assert_redirected_to query_url(assigns(:query))
    end
  end
  
  context "edit action" do
    should "render edit template" do
      get :edit, :id => Query.first
      assert_template 'edit'
    end
  end
  
  context "update action" do
    should "render edit template when model is invalid" do
      Query.any_instance.stubs(:valid?).returns(false)
      put :update, :id => Query.first
      assert_template 'edit'
    end
  
    should "redirect when model is valid" do
      Query.any_instance.stubs(:valid?).returns(true)
      put :update, :id => Query.first
      assert_redirected_to query_url(assigns(:query))
    end
  end
  
  context "destroy action" do
    should "destroy model and redirect to index action" do
      query = Query.first
      delete :destroy, :id => query
      assert_redirected_to queries_url
      assert !Query.exists?(query.id)
    end
  end
end
