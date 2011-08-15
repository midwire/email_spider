class QueriesController < ApplicationController
  def index
    @queries = Query.all
  end
  
  def show
    @query = Query.find(params[:id])
  end
  
  def new
    @query = Query.new
  end
  
  def create
    # @query = Query.new(params[:query])
    @query = Query.search(params[:query])
    if @query.save
      flash[:notice] = "Successfully created query."
      redirect_to @query
    else
      render :action => 'new'
    end
  end
  
  def edit
    @query = Query.find(params[:id])
  end
  
  def update
    @query = Query.find(params[:id])
    if @query.update_attributes(params[:query])
      flash[:notice] = "Successfully updated query."
      redirect_to @query
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @query = Query.find(params[:id])
    @query.destroy
    flash[:notice] = "Successfully destroyed query."
    redirect_to queries_url
  end
end
