# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def genre_graph_update
    remote_function(:url => {:controller => 'graphs', :action => 'genres', :id => 0}, :update => 'graphs')    
  end
  
  def clarify_title(add)
    content_for(:clarify_title) {" " + add}
  end
end
