class StatHeader < ActiveRecord::Base
  belongs_to :stat_category
  validates :name, :uniqueness => true

  #  give a name and returns { :display_name => name, :category => cat name }
  def self.lookup name
    upper_name = name.upcase

    entry = StatHeader.where(:name => upper_name).first

    if entry.nil? then
      return nil
    else
      return { :display_name => entry.display_name, :category => entry.stat_category.name }
    end
  end
end
