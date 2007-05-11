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
    make_choices()
  end

  def mail_choices
    make_choices()
    
    email = ClubcarMailer.create_decision(@choices) 
    ClubcarMailer.deliver(email)
    render(:text => "<pre>" + email.encoded + "</pre>") 
  end

  private

  def clarify_title
    @clarifyTitle = 's'
  end


  def make_choices
    # Make everything an instance variable so we can display debugging
    # info in the view.
    @scored_genres = Tag.find_scored_genres

    @choices = Array.new;

    0.upto(1) do |i|
      @choices[i] = Hash.new;
      @choices[i]['genre'] = choose_scored_genre(@scored_genres, @choices[i])
      @choices[i]['scored_genres'] = Array.new(@scored_genres)
      @scored_genres.delete_if { |g| g == @choices[i]['genre'] }
      @choices[i]['restaurant'] = choose_restaurant(@choices[i]['genre'], @choices[i])
    end
  end

  def choose_weighted(h, t)
    r = rand(t+1)

    scores = h.keys.sort
    begin 
      test = scores.shift;
    end while test < r

    h[test]
  end

  def choose_scored_genre(scored_genres, debugH) 
    debugH['genre_min'] = Struct.new(:total, 
				     :distance,
				     :score).new(0)

    scored_genres.inject(debugH['genre_min']) do |memo,t| 
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

    debugH['weighted_genres'] = scored_genres.inject(Hash.new) do |memo, t|
      # Every genre gets one just for showing up (zero votes is really 1 vote)
      value = VOTE_TO_DISTANCE_RATIO

      if (debugH['genre_min'].score > 0) 
	value += VOTE_TO_DISTANCE_RATIO * 
	  t.score_per_restaurant / debugH['genre_min'].score
      end

      if t.distance.nil?
	d = DISTANCE_MAX
      else
	d = t.distance.to_f
	d = d > DISTANCE_MAX ? DISTANCE_MAX : d
      end

      if (debugH['genre_min'].distance > 0) 
	value += d / debugH['genre_min'].distance.to_f
      end

      debugH['genre_min'].total += value.round
      memo[debugH['genre_min'].total] = t

      # "return" the memo for the next round
      memo
    end

    return choose_weighted(debugH['weighted_genres'], debugH['genre_min'].total)
  end

  def choose_restaurant(genre, debugH) 
    debugH['scored_restaurants'] = Restaurant.find_all_by_tag_with_active_scores(genre)

    debugH['restaurant_total'] = 0

    debugH['weighted_restaurants'] = debugH['scored_restaurants'].inject(Hash.new) do |memo, r|
      # One for showing
      debugH['restaurant_total'] += 1 + r.total.to_i
      memo[debugH['restaurant_total']] = r

      memo
    end

    debugH['restaurant'] = choose_weighted(debugH['weighted_restaurants'], debugH['restaurant_total'])

  end

end

