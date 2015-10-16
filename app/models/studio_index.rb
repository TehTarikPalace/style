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

  #path is expected to be "\\server\share\path\to\env\the_file.StudioEnvironment"
  def dump_studio_environment path
    #vet the path
    if path.nil? then
      return nil
    else
      #rebuild the path and dump the stuff
      splited = path.split("\\").delete_if{|x|x.empty? }
      path_to_dataenv = splited[2..splited.length].join("\\")

      #connect and get dump
      client = Sambal::Client.new(:domain => self.workgroup, :host => splited[0], :share => splited[1],
        :user => self.username, :password => self.password)

      dump_file = "/tmp/#{SecureRandom.hex }.tmp"
      client.get(path_to_dataenv, dump_file)
      contents = File.read(dump_file)
      File.delete(dump_file)

      return contents
    end
  end

  def scan_settings
    #get the settings dump
    settings_dump = dump_settings

    #cycle through environment files
    if settings_dump.empty? or settings_dump.nil? then
      return nil
    else
      xml = Nokogiri::XML settings_dump
      dataEnvs = xml.search("DataEnvironmentFiles").children.map{|x| x.text}

      return dataEnvs
    end

  end

end
