class RestaurantsController < ApplicationController
  before_filter :clarify_title

  #TESTING
  layout "application"
  
  # This, too, should be configurable
  TOTAL_CHOICES=2

  # GET /restaurants
  # GET /restaurants.xml
  def index
    @restaurants = Restaurant.find(:all, :order => :name)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @restaurants }
    end
  end

  # GET /restaurants/1
  # GET /restaurants/1.xml
  def show
    # For some reason, when I :include => :genres, it's empty
    @restaurant = Restaurant.find(params[:id], :include => [ :tags ]) #, :genres

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @restaurant }
    end
  end

  # GET /restaurants/new
  def new
    @restaurant = Restaurant.new
  end

  # GET /restaurants/1;edit
  def edit
    @restaurant = Restaurant.find(params[:id])
  end

  # POST /restaurants
  # POST /restaurants.xml
  def create
    @restaurant = Restaurant.new(params[:restaurant])

    respond_to do |format|
      if @restaurant.save
        flash[:notice] = 'Restaurant was successfully created.'
        format.html { redirect_to restaurant_url(@restaurant) }
        format.xml  { head :created, :location => restaurant_url(@restaurant) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @restaurant.errors }
      end
    end
  end

  # PUT /restaurants/1
  # PUT /restaurants/1.xml
  def update
    @restaurant = Restaurant.find(params[:id])

    respond_to do |format|
      if @restaurant.update_attributes(params[:restaurant])
        flash[:notice] = 'Restaurant was successfully updated.'
        format.html { redirect_to restaurant_url(@restaurant) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @restaurant.errors }
      end
    end
  end

  # DELETE /restaurants/1
  # DELETE /restaurants/1.xml
  def destroy
    @restaurant = Restaurant.find(params[:id])
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
    #render(:text => "<pre>" + email.encoded + "</pre>") 
    puts "QUEUE: ", email.to;
  end

  #private

  def make_choices
    # Make everything an instance variable so we can display debugging
    # info in the view.
    @scored_genres = Tag.find_all_by_bounded_date_distance

    raise "Empty scored genres! (is anyone present?)" if @scored_genres.empty?

    @choices = Array.new;

    0.upto(TOTAL_CHOICES - 1) do |i|
      @choices[i] = Hash.new;
      # make a copy, so we can delete from it
      @choices[i]['scored_genres'] = Array.new(@scored_genres)

      r = choose_restaurant(@choices[i])

      @scored_genres.delete_if { |g| !r.genres.select { |t| t == g }.empty? }
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
    debugH['total'] = 0
    logger.debug("ENTER CHOOSE SCORED GENRES: #{scored_genres.length}")

    debugH['weighted_genres'] = scored_genres.inject(Hash.new) do |memo, t|
      debugH['total'] += t.weight
      memo[debugH['total']] = t

      logger.debug "GENRE: #{t.weight} : #{debugH['total']} | #{t.name}"

      # "return" the memo for the next round
      memo
    end

    return choose_weighted(debugH['weighted_genres'], 
                           debugH['total'])
  end

  def choose_restaurant(debugH) 
    debugH['scored_restaurants'] = Restaurant.find_all_by_tags_with_active_scores(@scored_genres)

    debugH['restaurant_total'] = 0

    debugH['weighted_restaurants'] = debugH['scored_restaurants'].inject(Hash.new) do |memo, r|
      debugH['restaurant_total'] += r.weight.to_i
      memo[debugH['restaurant_total']] = r
      memo
    end

    debugH['restaurant'] = choose_weighted(debugH['weighted_restaurants'], debugH['restaurant_total'])
    return debugH['restaurant']
  end

  def clarify_title
  end

end

