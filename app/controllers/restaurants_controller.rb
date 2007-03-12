class RestaurantsController < ApplicationController
  # GET /restaurants
  # GET /restaurants.xml

  before_filter :clarify_title

  def index
    @restaurants = Restaurant.find(:all, :order => :name)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @restaurants.to_xml }
    end
  end

  # GET /restaurants/1
  # GET /restaurants/1.xml
  def show
    # For some reason, when I :include => :genres, it's empty
    @restaurant = Restaurant.find(params[:id], :include => [ :tags ]) #, :genres
    @clarifyTitle = ' ' + @restaurant.name

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @restaurant.to_xml }
    end
  end

  # GET /restaurants/new
  def new
    @restaurant = Restaurant.new
    @clarifyTitle = ''
  end

  # GET /restaurants/1;edit
  def edit
    @restaurant = Restaurant.find(params[:id])
    @clarifyTitle = ' ' + @restaurant.name
  end

  # POST /restaurants
  # POST /restaurants.xml
  def create
    @restaurant = Restaurant.new(params[:restaurant])
    @clarifyTitle = ' ' + @restaurant.name

    respond_to do |format|
      if @restaurant.save
        flash[:notice] = 'Restaurant was successfully created.'
        format.html { redirect_to restaurant_url(@restaurant) }
        format.xml  { head :created, :location => restaurant_url(@restaurant) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @restaurant.errors.to_xml }
      end
    end
  end

  # PUT /restaurants/1
  # PUT /restaurants/1.xml
  def update
    @restaurant = Restaurant.find(params[:id])
    @clarifyTitle = ' ' + @restaurant.name

    respond_to do |format|
      if @restaurant.update_attributes(params[:restaurant])
        flash[:notice] = 'Restaurant was successfully updated.'
        format.html { redirect_to restaurant_url(@restaurant) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @restaurant.errors.to_xml }
      end
    end
  end

  # DELETE /restaurants/1
  # DELETE /restaurants/1.xml
  def destroy
    @restaurant = Restaurant.find(params[:id])
    @clarifyTitle = ' ' + @restaurant.name
    @restaurant.destroy

    respond_to do |format|
      format.html { redirect_to restaurants_url }
      format.xml  { head :ok }
    end
  end

private

  def clarify_title
    @clarifyTitle = 's'
  end
end
