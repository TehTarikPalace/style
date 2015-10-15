class StudioIndex < ActiveRecord::Base
  after_initialize :default_values

  def default_values
    self.workgroup ||= "WORKGROUP"
  end

  def full_path
    "//#{server}/#{share}/#{path}"
  end

  def dump_settings
    client = Sambal::Client.new(:domain => self.workgroup, :host => self.server, :share => self.share,
      :user => self.username, :password => self.password)

    client.cd self.path

    begin
      dump_file = "/tmp/#{SecureRandom.hex }.tmp"
      client.get("settings.xml", dump_file)
      contents = File.read(dump_file)
      File.delete(dump_file)
      return contents
    rescue Exception => e
      Rails.logger.info e
      "Failed to execute command"
    end
  end

  def dump_studio_environment path = nil
    #vet the path
    if path.nil? then
      contents = self.dump_settings
      if contents.nil? then
        return nil
      else
        xml_data = Nokogiri::XML contents
        dataEnvFiles = xml_data.css "DataEnvironmentFiles"
        if dataEnvFiles.empty? then
          return nil
        else
          return dataEnvFiles.children.map{|x| x.children.text }
        end
      end
    end
  end

  def scan_settings
    
  end
end
