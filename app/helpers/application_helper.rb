module ApplicationHelper
  
  def get_params
    parameters = ""
    if (not params[:page].nil?)
      parameters = parameters + "?page=" + params[:page]
      if not params[:search_string].nil?
        parameters = parameters + "&search_string=" + params[:search_string]
      end
      if not params[:subpage].nil?
        parameters = parameters + "&subpage=" + params[:subpage]
      end  
    elsif not params[:search_string].nil?
      parameters = parameters + "?search_string=" + params[:search_string]
    elsif not params[:subpage].nil?
        parameters = parameters + "?subpage=" + params[:subpage]
    end
    parameters
  end
  
  def get_params_no_subpage
    parameters = ""
    if (not params[:page].nil?)
      parameters = parameters + "?page=" + params[:page]
      if not params[:search_string].nil?
        parameters = parameters + "&search_string=" + params[:search_string]
      end
    elsif not params[:search_string].nil?
      parameters = parameters + "?search_string=" + params[:search_string]
    end
    parameters
  end
  
  def page_title(title_text, link_text, link)
    string = '<h2>' + title_text + '</h2>' + link_to(link_text, url_for(link) + get_params, :class => "underlined") + '<br />' + '<br />'
    string.html_safe
  end

  def page_title_no_links(title_text)
    string = '<h2>' + title_text + '</h2>' + '<br />' + '<br />'
    string.html_safe
  end
  
  def page_title_no_params(title_text, link_text, link)
    string = '<h2>' + title_text + '</h2>' + link_to(link_text, url_for(link), :class => "underlined") + '<br />' + '<br />'
    string.html_safe
  end
  
  def page_title_multiple_links(title_text, link1_text, link1, link2_text, link2)
    string = '<h2>' + title_text + '</h2>' + link_to(link1_text, url_for(link1) + get_params, :class => "underlined")
    if (not link2_text.nil?) && (not link2.nil?)
      string = string + " | " + link_to(link2_text, url_for(link2) + get_params, :class => "underlined")
    end
    string = string + '<br />' + '<br />'
    string.html_safe
  end
  
  def page_title_multiple_links_no_subpage_for_back(title_text, link_text, link, back_text, back_link)
    string = '<h2>' + title_text + '</h2>' + link_to(link_text, url_for(link) + get_params, :class => "underlined")
    if (not back_text.nil?) && (not back_link.nil?)
      string = string + " | " + link_to(back_text, url_for(back_link) + get_params_no_subpage, :class => "underlined")
    end
    string = string + '<br />' + '<br />'
    string.html_safe
  end
    
  def error_messages(object)
    string1 = ''
    string2 = ''
    string3 = ''
    if object.errors.count > 0
  	  string1 = 
  	  '<div id="errorExplanation">
    	    <p>' + pluralize(object.errors.count, "error") + ' prohibited this item from being saved:</p>
    	    <ul>'
    	object.errors.full_messages.each do |msg|
    	  string2 = string2 + '<li>' + msg + '</li>'
      end
    	string3 = '</ul></div>'
    end
    (string1 + string2 + string3).html_safe
  end
  
  def table_header(object, titles)
      string = ''
      # do table titles
      if object.length > 0
        string = '<tr>'
        titles.each do |title|
          string = string + '<th>' + title + '</th>'
        end
        string = string + '</tr>'
      else
        string = '<tr><td>No records have been created.</td></tr>'
      end
      string.html_safe
  end
  
  def table_row(cells, object, edit_path)
    string = '<tr>'
    cells.each do |data|
      string = string + '<td>' + data.to_s + '</td>'
    end
    if not edit_path.nil?
      string = string + '<td>' + link_to(image_tag("page_white_edit.png", :border => 0), url_for(edit_path) + get_params, :title => 'Edit') + '</td>'
    end
    string = string + '<td>' + link_to(image_tag("cross.png", :border => 0), object, :confirm => 'Are you sure that you want to permanently delete this item?', :method => :delete, :title => 'Delete') + '</td></tr>'
    string.html_safe
  end
  
  def table_row_with_details(cells, object, edit_path, details_path)
    string = '<tr>'
    cells.each do |data|
      string = string + '<td>' + data.to_s + '</td>'
    end
    if not details_path.nil?
      string = string + '<td>' + link_to(image_tag("page_white_magnify.png", :border => 0), url_for(details_path) + get_params, :title => 'Details') + '</td>'
    end
    if not edit_path.nil?
      string = string + '<td>' + link_to(image_tag("page_white_edit.png", :border => 0), url_for(edit_path) + get_params, :title => 'Edit') + '</td>'
    end
    string = string + '<td>' + link_to(image_tag("cross.png", :border => 0), object, :confirm => 'Are you sure that you want to permanently delete this item?', :method => :delete, :title => 'Delete') + '</td></tr>'
    string.html_safe
  end
  
  def pagination(items)
    if (not items.blank?) && (not paginate(items).empty?)
      string = '<nav class="pagination"><span class="page_info">'
      string = string + page_entries_info(items) + '</span></nav>'
      string = string + paginate(items) + '</br>'
      string.html_safe
    end
  end
  
  def subpagination(items)
    if (not items.blank?) && (not paginate(items).empty?)
      string = '<nav class="pagination"><span class="page_info">'
      string = string + page_entries_info(items) + '</span></nav>'
      string = string + paginate(items, :param_name => :subpage) + '</br>'
      string.html_safe
    end
  end
    
     
end
