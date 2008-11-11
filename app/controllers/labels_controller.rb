class LabelsController < ApplicationController

  before_filter :find_restaurant
  before_filter :clarify_title

  # GET /labels
  # GET /labels.xml
  def index
    @labels = Label.find(:all, :include => :tag, :order => 'tags.canonical')

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @labels.to_xml }
    end
  end

  # GET /labels/1
  # GET /labels/1.xml
  def show
    @label = Label.find(params[:id] )

    @clarifyTitle += '/' + @label.tag.name

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @label.to_xml }
    end
  end

  # GET /labels/new
  def new
    @label = Label.new
  end

  # GET /labels/1;edit
  def edit
    @label = Label.find(params[:id])
    @clarifyTitle += '/' + @label.tag.name
  end

  # POST /labels
  # POST /labels.xml
  def create
    @label = Label.new(params[:label])

    respond_to do |format|
      if @label.save
        flash[:notice] = 'Label was successfully created.'
        format.html { redirect_to label_url(@label) }
        format.xml  { head :created, :location => label_url(@label) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @label.errors.to_xml }
      end
    end
  end

  # PUT /labels/1
  # PUT /labels/1.xml
  def update
    @label = Label.find(params[:id])
    @clarifyTitle += '/' + @label.tag.name

    respond_to do |format|
      if @label.update_attributes(params[:label])
        flash[:notice] = 'Label was successfully updated.'
        format.html { redirect_to label_url(@label) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @label.errors.to_xml }
      end
    end
  end

  # DELETE /labels/1
  # DELETE /labels/1.xml
  def destroy
    @label = Label.find(params[:id])
    @label.destroy
    
    flash[:notice] = 'Label removed'

    respond_to do |format|
      format.html { redirect_to restaurant_url(@restaurant) }
      format.xml  { head :ok }
    end
  end


  def change
    labels = Label.find_all_by_restaurant_id(@restaurant_id, 
                                             :include => [:tag, :tag_type])
    @tags = Array.new
    @genres = Array.new
    
    for label in labels
      case label.tag.tag_type.name
      when 'Tag'
        @tags << label
      when 'Genre'
        @genres << label
      end
    end
    
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => labels.to_xml }
    end
  end

  def save
    @restaurant.tags << Tag.fetch(Tag.tag_type, param[:new_tags])
    @restaurant.genres << Tag.fetch(Tag.genre_type, param[:new_genres])
    # is this necessary?
    @restaurant.save

    respond_to do |format|
        format.html { redirect_to change_labels_url(@restaurant_id) }
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

  def clarify_title
    @clarifyTitle = ' for ' + @restaurant.name
  end

end
