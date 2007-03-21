class RestaurantsController < ApplicationController
  # GET /restaurants
  # GET /restaurants.xml

  before_filter :clarify_title

  # This should be configurable (note, setting this value to < 0.5 could
  # cause collisions in the algorithm below)
  VOTE_TO_DISTANCE_RATIO = 4.0
  
  # This, too, should be configurable
  DISTANCE_MAX = 14 # (after two weeks, does it really matter?)

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

  # GET /restaurants;choose
  def choose
    # Make everything an instance variable so we can display debugging
    # info in the view.
    @genre_min = Struct.new(:total, 
		      :distance,
		      :score).new(0)

    @scored_genres = Tag.find_scored_genres

    @scored_genres.inject(@genre_min) do |memo,t| 
      ms = memo.score
      spr = t.score_per_restaurant

      # The Float.< could cause trouble
      if (!spr.nil? && spr > 0 && (ms.nil? || spr < ms))
	memo.score = spr
      end

      md = memo.distance
      td = t.distance.to_i
      if (!td.nil? && td > 0 && (md.nil? || td < md))
	memo.distance = td
      end

      # "return" the memo for the next round
      memo
    end

    @weighted_genres = @scored_genres.inject(Hash.new) do |memo, t|
      # Every genre gets one just for showing up (zero votes is really 1 vote)
      value = VOTE_TO_DISTANCE_RATIO

      if (@genre_min.score > 0) 
	value += VOTE_TO_DISTANCE_RATIO * 
	  t.score_per_restaurant / @genre_min.score
      end

      if t.distance.nil?
	d = DISTANCE_MAX
      else
	d = t.distance.to_f
	d = d > DISTANCE_MAX ? DISTANCE_MAX : d
      end

      if (@genre_min.distance > 0) 
	value += d / @genre_min.distance.to_f
      end

      @genre_min.total += value.round
      memo[@genre_min.total] = t

      # "return" the memo for the next round
      memo
    end

    @genre = choose_weighted(@weighted_genres, @genre_min.total)

    @scored_restaurants = Restaurant.find_all_by_tag_with_active_scores(@genre)

    @restaurant_min = Struct.new(:total, :score).new(0)

    @scored_restaurants.inject(@restaurant_min) do |memo, r|
      ms = memo.score
      rt = r.total.to_i

      # The Float.> could cause trouble
      if (!rt.nil? && rt > 0 && (ms.nil? || rt < ms)) 
	memo.score = rt
      end

      # "return" the memo for the next round
      memo
    end

    @weighted_restaurants = @scored_restaurants.inject(Hash.new) do |memo,r|
      # One for showing up
      value = 1
      if (@restaurant_min.score > 0)
	value += r.total.to_f / @restaurant_min.score
      end
      
      @restaurant_min.total += value.round
      memo[@restaurant_min.total] = r

      memo
    end

    @restaurant = choose_weighted(@weighted_restaurants, @restaurant_min.total)

  end

private

  def clarify_title
    @clarifyTitle = 's'
  end

  def choose_weighted(h, t)
    r = rand(t+1)

    scores = h.keys.sort
    begin 
      test = scores.shift;
    end while test < r

    h[test]
  end
end

