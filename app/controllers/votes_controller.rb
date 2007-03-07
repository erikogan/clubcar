class VotesController < ApplicationController
  # GET /votes
  # GET /votes.xml
  def index
    @votes = Vote.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @votes.to_xml }
    end
  end

  # GET /votes/1
  # GET /votes/1.xml
  def show
    @vote = Vote.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @vote.to_xml }
    end
  end

  # GET /votes/new
  def new
    @vote = Vote.new
  end

  # GET /votes/1;edit
  def edit
    @vote = Vote.find(params[:id])
  end

  # POST /votes
  # POST /votes.xml
  def create
    @vote = Vote.new(params[:vote])

    respond_to do |format|
      if @vote.save
        flash[:notice] = 'Vote was successfully created.'
        format.html { redirect_to vote_url(@vote) }
        format.xml  { head :created, :location => vote_url(@vote) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vote.errors.to_xml }
      end
    end
  end

  # PUT /votes/1
  # PUT /votes/1.xml
  def update
    @vote = Vote.find(params[:id])

    respond_to do |format|
      if @vote.update_attributes(params[:vote])
        flash[:notice] = 'Vote was successfully updated.'
        format.html { redirect_to vote_url(@vote) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vote.errors.to_xml }
      end
    end
  end

  # DELETE /votes/1
  # DELETE /votes/1.xml
  def destroy
    @vote = Vote.find(params[:id])
    @vote.destroy

    respond_to do |format|
      format.html { redirect_to votes_url }
      format.xml  { head :ok }
    end
  end
end
