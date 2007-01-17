class TagTypesController < ApplicationController
  # GET /tag_types
  # GET /tag_types.xml
  def index
    @tag_types = TagType.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @tag_types.to_xml }
    end
  end

  # GET /tag_types/1
  # GET /tag_types/1.xml
  def show
    @tag_type = TagType.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @tag_type.to_xml }
    end
  end

  # GET /tag_types/new
  def new
    @tag_type = TagType.new
  end

  # GET /tag_types/1;edit
  def edit
    @tag_type = TagType.find(params[:id])
  end

  # POST /tag_types
  # POST /tag_types.xml
  def create
    @tag_type = TagType.new(params[:tag_type])

    respond_to do |format|
      if @tag_type.save
        flash[:notice] = 'TagType was successfully created.'
        format.html { redirect_to tag_type_url(@tag_type) }
        format.xml  { head :created, :location => tag_type_url(@tag_type) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tag_type.errors.to_xml }
      end
    end
  end

  # PUT /tag_types/1
  # PUT /tag_types/1.xml
  def update
    @tag_type = TagType.find(params[:id])

    respond_to do |format|
      if @tag_type.update_attributes(params[:tag_type])
        flash[:notice] = 'TagType was successfully updated.'
        format.html { redirect_to tag_type_url(@tag_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tag_type.errors.to_xml }
      end
    end
  end

  # DELETE /tag_types/1
  # DELETE /tag_types/1.xml
  def destroy
    @tag_type = TagType.find(params[:id])
    @tag_type.destroy

    respond_to do |format|
      format.html { redirect_to tag_types_url }
      format.xml  { head :ok }
    end
  end
end
