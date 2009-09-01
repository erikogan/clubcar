class TagsController < ApplicationController
  # GET /tags
  # GET /tags.xml
  def index
    # I know there is a more clever way to do this, but functionally this is
    # what it would do under the hood.    
    @tags = Tag.find(:all, :include => :taggings)
    @by_context = {}
    for tag in @tags do
      for tagging in tag.taggings do
        unless @by_context.has_key?(tagging.context)
          @by_context[tagging.context] = Set.new
        end
        @by_context[tagging.context] << tag
      end
    end

    @contexts = @by_context.keys.sort

    respond_to do |format|
      format.html # index.html.haml
      format.xml  { render :xml => @by_context }
    end
  end

  # GET /tags/1
  # GET /tags/1.xml
  def show
    # Can't include the polymorphic end-point, but there shouldn't be many
    # (famous last words)
    @tag = Tag.find(params[:id], :include => :taggings)
    @by_type = @tag.taggings.group_by(&:taggable_type).to_hash

    @types = @by_type.keys.sort
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tag }
    end
  end

  # GET /tags/new
  # GET /tags/new.xml
  # POST /tags
  # POST /tags.xml
  ##### Tags should only be created by tagging items

  # GET /tags/1/edit
  def edit
    @tag = Tag.find(params[:id])
  end

  # PUT /tags/1
  # PUT /tags/1.xml
  def update
    @tag = Tag.find(params[:id])

    respond_to do |format|
      if @tag.update_attributes(params[:tag])
        flash[:notice] = 'Tag was successfully updated.'
        format.html { redirect_to(@tag) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.xml
  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy

    respond_to do |format|
      format.html { redirect_to(tags_url) }
      format.xml  { head :ok }
    end
  end
end
