class StatisticsController < ApplicationController
  def index
    @categories = StatCategory.all
    @headers = StatHeader.all
  end

  def edit_categories
    @categories = StatCategory.all
  end

  def new_category
    js false
    respond_to do |format|
      format.template
      format.html{
        render :template => "statistics/new_category.template", :content_type => "text/template"
      }
    end
  end

  def update_categories
    #process categories

    #update current ones

    #delete ones not in the list

    #add new ones
    flash[:notice] = "Categories Updated"
    redirect_to edit_categories_statistics_path
  end

  #  GET    /settings/statistics/edit_headers
  def edit_headers
    @headers = StatHeader.all
  end

  def new_header
    js false
    respond_to do |format|
      format.template
      format.html{
        render :template => "statistics/new_header.template", :content_type => "text/template"
      }
    end
  end
end
