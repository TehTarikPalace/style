class StudioIndex < ActiveRecord::Base
  after_initialize :default_values

  def default_values
    self.workgroup ||= "WORKGROUP"
  end

  def full_path
    "//#{server}/#{share}/#{path}"
  end
end
