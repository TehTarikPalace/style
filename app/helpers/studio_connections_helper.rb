module StudioConnectionsHelper
  # find stuff inside the dir list and remove the stuff in the dir list
  def findings dir_list, search_pattern
    search_term = dir_list.select{|x| /#{search_pattern}/ =~ x}
    if search_term.empty? then
      "None detected"
    else
      dir_list.delete_if{|x| /#{search_pattern}/ =~ x }
      content_tag(:ul, search_term.map{ |x| content_tag :li, x}.join.html_safe).html_safe
    end
  end
end
