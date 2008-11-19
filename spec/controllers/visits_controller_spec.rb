require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VisitsController do
  it_should_behave_like 'login'

  def mock_restaurant(stubs={})
    @mock_restaurant ||= mock_model(Restaurant, stubs)
  end
  
  def mock_visit(stubs={})
    @mock_visit ||= mock_model(Visit, stubs)
  end

  def mock_array()
    @mock_visits ||= mock("Array of Visits")
  end

  before do
    Restaurant.should_receive(:find).with("42").and_return(mock_restaurant)
  end

  after do
    assigns[:restaurant].should equal(mock_restaurant)
  end
  
  
  describe "responding to GET index" do

    it "should expose all visits as @visits" do
      mock_restaurant.should_receive(:visits).and_return(visits = [mock_visit])      
      get :index, :restaurant_id => "42"
      response.should be_success
      response.should render_template("index")
      assigns[:visits].should == visits
    end

    describe "with mime type of xml" do
  
      it "should render all visits as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        mock_restaurant.should_receive(:visits).and_return(visits = mock("Array of Visits"))
        visits.should_receive(:sort).and_return(visits)
        visits.should_receive(:to_xml).and_return("generated XML")
        get :index, :restaurant_id => "42"
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do
    before do
      mock_restaurant.should_receive(:visits).and_return(visits = [mock_visit])
      visits.should_receive(:find).with("37").and_return(mock_visit)
    end
    
    it "should expose the requested visit as @visit" do
      get :show, :id => "37", :restaurant_id => "42"
      response.should be_success
      response.should render_template("show")
      assigns[:visit].should equal(mock_visit)
    end
    
    describe "with mime type of xml" do

      it "should render the requested visit as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        mock_visit.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37", :restaurant_id => "42"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new visit as @visit" do
      Visit.should_receive(:new).and_return(mock_visit)
      get :new, :restaurant_id => "42"
      response.should be_success
      response.should render_template("new")
      assigns[:visit].should equal(mock_visit)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested visit as @visit" do
      mock_restaurant.should_receive(:visits).and_return(visits = [mock_visit])
      visits.should_receive(:find).with("37").and_return(mock_visit)
      get :edit, :id => "37", :restaurant_id => "42"
      response.should be_success
      response.should render_template("edit")
      assigns[:visit].should equal(mock_visit)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      before do
        mock_restaurant.should_receive(:visits).and_return(mock_array)
        mock_array.should_receive(:<<).with(mock_visit)
        mock_restaurant.should_receive(:save).and_return(true)
      end
      
      it "should expose a newly created visit as @visit" do
        Visit.should_receive(:new).with({'these' => 'params'}).and_return(mock_visit(:save => true))
        post :create, :visit => {:these => 'params'}, :restaurant_id => "42"
        assigns(:visit).should equal(mock_visit)
      end

      it "should redirect to the created visit" do
        Visit.stub!(:new).and_return(mock_visit(:save => true))
        post :create, :visit => {}, :restaurant_id => "42"
        response.should redirect_to(restaurant_visit_url(mock_restaurant, mock_visit))
      end
      
    end
    
    describe "with invalid params" do

      before do
        mock_restaurant.should_receive(:visits).and_return(mock_array)
        mock_array.should_receive(:<<).with(mock_visit)
        mock_restaurant.should_receive(:save).and_return(false)
      end

      it "should expose a newly created but unsaved visit as @visit" do
        Visit.stub!(:new).with({'these' => 'params'}).and_return(mock_visit(:save => false))
        post :create, :visit => {:these => 'params'}, :restaurant_id => "42"
        assigns(:visit).should equal(mock_visit)
      end

      it "should re-render the 'new' template" do
        Visit.stub!(:new).and_return(mock_visit(:save => false))
        post :create, :visit => {}, :restaurant_id => "42"
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do
    before do
      mock_restaurant.should_receive(:visits).and_return(mock_array)
    end

    describe "with valid params" do

      it "should update the requested visit" do
        mock_array.should_receive(:find).with("37").and_return(mock_visit)
        mock_visit.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :visit => {:these => 'params'}, :restaurant_id => "42"
      end

      it "should expose the requested visit as @visit" do
        mock_array.should_receive(:find).with("1").and_return(mock_visit(:update_attributes => true))
        put :update, :id => "1", :visit =>{}, :restaurant_id => "42"
        assigns(:visit).should equal(mock_visit)
      end

      it "should redirect to the visit" do
        mock_array.should_receive(:find).with("1").and_return(mock_visit(:update_attributes => true))
        put :update, :id => "1", :visit =>{}, :restaurant_id => "42"
        response.should redirect_to(restaurant_visit_url(mock_restaurant, mock_visit))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested visit" do
        mock_array.should_receive(:find).with("37").and_return(mock_visit)
        mock_visit.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :visit => {:these => 'params'}, :restaurant_id => "42"
      end

      it "should expose the visit as @visit" do
        mock_array.should_receive(:find).with("1").and_return(mock_visit(:update_attributes => false))
        put :update, :id => "1", :visit =>{}, :restaurant_id => "42"
        assigns(:visit).should equal(mock_visit)
      end

      it "should re-render the 'edit' template" do
        mock_array.should_receive(:find).with("1").and_return(mock_visit(:update_attributes => false))
        put :update, :id => "1", :visit =>{}, :restaurant_id => "42"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do
    before do
      mock_restaurant.should_receive(:visits).at_least(:once).and_return(mock_array)
      mock_array.should_receive(:find).with(37).and_return(mock_visit)
      mock_array.should_receive(:delete).with(mock_visit)
      mock_visit.should_receive(:destroy)
    end

    it "should destroy the requested visit" do
      delete :destroy, :id => "37", :restaurant_id => "42"
    end
  
    it "should redirect to the visits list" do
      delete :destroy, :id => "37", :restaurant_id => "42"
      response.should redirect_to(restaurant_visits_url(mock_restaurant))
    end

  end

end
