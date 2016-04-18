module StudioConnectionsHelper
  # find stuff inside the dir list and remove the stuff in the dir list
  def findings dir_list, search_pattern

    #some agreed standards
    project_type ="(?:BLKENTRY|BLKREVAL|PEM|PREDRILL|POSTDRILL|RGN)"
    vintange = "[0-9]{4}"
    project_sequence = "[[:upper:]]{1}"
    project_title = "#{project_type}_[A-Z0-9]+_#{vintange}"

    search_pattern = search_pattern.gsub /!project_title!/, "#{project_title}"
    search_term = dir_list.select{|x| /#{search_pattern}/ =~ x}

    if search_term.empty? then
      "None detected"
    else
      dir_list.delete_if{|x| /#{search_pattern}/ =~ x }
      content_tag(:ul, search_term.map{ |x| content_tag :li, x.gsub(/~/, "/")}.join.html_safe).html_safe
    end
  end
end
