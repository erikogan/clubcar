class VisitsController < ApplicationController
  before_filter :find_restaurant

  # GET /visits
  # GET /visits.xml
  def index
    # @visits = Visit.find(:all)
    @visits = @restaurant.visits.sort {|a,b| b.date <=> a.date }

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @visits.to_xml }
    end
  end

  # GET /visits/1
  # GET /visits/1.xml
  def show
    # @visit = Visit.find(params[:id])
    @visit = @restaurant.visits.find(param[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @visit.to_xml }
    end
  end

  # GET /visits/new
  def new
    @visit = Visit.new
  end

  # GET /visits/1;edit
  def edit
    # @visit = Visit.find(params[:id])
    @visit = @restaurant.visits.find(param[:id])
  end

  # POST /visits
  # POST /visits.xml
  def create
    @visit = Visit.new(params[:visit])

    respond_to do |format|
      if @visit.save
        flash[:notice] = 'Visit was successfully created.'
        format.html { redirect_to visit_url(@visit) }
        format.xml  { head :created, :location => visit_url(@visit) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @visit.errors.to_xml }
      end
    end
  end

  # PUT /visits/1
  # PUT /visits/1.xml
  def update
    # @visit = Visit.find(params[:id])
    @visit = @restaurant.visits.find(param[:id])

    respond_to do |format|
      if @visit.update_attributes(params[:visit])
        flash[:notice] = 'Visit was successfully updated.'
        format.html { redirect_to visit_url(@visit) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @visit.errors.to_xml }
      end
    end
  end

  # DELETE /visits/1
  # DELETE /visits/1.xml
  def destroy
    # @visit = Visit.find(params[:id])
    # why does only delete need the .to_i ?
    visit = @restaurant.visits.find(params[:id].to_i)
    visit.destroy
    @restaurant.visits.delete(visit)

    @visit.destroy

    respond_to do |format|
      format.html { redirect_to visits_url }
      format.xml  { head :ok }
    end
  end

private

  def find_restaurant
    @restaurant_id = params[:restaurant_id]
    # ActiveRecord .find methods throw an exception when they fail, this
    # needs to be reworked
    begin
      unless @restaurant_id.blank?
	@restaurant = Restaurant.find(@restaurant_id)
	return
      end
    rescue
      # The return handled the base case, everything else is redirected
    end

    redirect_to restaurants_url
  end
end
