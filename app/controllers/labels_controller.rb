class LabelsController < ApplicationController
  # GET /labels
  # GET /labels.xml
  def index
    @labels = Label.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @labels.to_xml }
    end
  end

  # GET /labels/1
  # GET /labels/1.xml
  def show
    @label = Label.find(params[:id])

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

    respond_to do |format|
      format.html { redirect_to labels_url }
      format.xml  { head :ok }
    end
  end
end
