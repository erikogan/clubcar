#---
# Excerpted from "Agile Web Development with Rails, 2nd Ed."
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rails2 for more book information.
#---
class TaggedBuilder < ActionView::Helpers::FormBuilder
  
  # <div id="product_description_field" class="taggedField">
  #   <label for="product_description">Description</label><br/>
  #   <%= form.text_area 'description' %>
  # </div>
  def self.create_tagged_field(method_name)
    define_method(method_name) do |label, *args|
      field_id = "#{@object_name}_#{label}"
      @template.content_tag("div",
			    @template.content_tag("label" , 
						  label.to_s.humanize, 
						  :for => field_id) +
			    "<br/>" +
			    super,
			    :id => "#{field_id}_field", :class => :tagged_field
			    )

    end
  end
  
  
  field_helpers.each do |name|
    create_tagged_field(name)
  end

end
