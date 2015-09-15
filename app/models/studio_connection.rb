require "oci8"
class StudioConnection < ActiveRecord::Base
  validates_presence_of :username, :password, :oracle_host, :oracle_instance
  after_initialize :default_values

  def default_values
    self.port ||= 1521
  end

  #execute a sql statement, return an array of results
  def query sql_statement, *bindvars
    oracle = OCI8.new(self.username, self.password, "//#{self.oracle_host}:#{self.port}/#{self.oracle_instance}")
    cursor = oracle.exec(sql_statement, *bindvars)
    result = Array.new

    while r = cursor.fetch
      result << r
    end
    cursor.close
    oracle.logoff

    return result
  end

  # returns a hash of :collection_name => {:collection_property => value} given by the path in the repo
  def browse repo_name, path_name = "/" ,parent_guid = 0
      return_items = Hash.new

      if path_name == "/" then

        results = query "select
          name, id, guid, object_update_date, object_update_user
          from #{repo_name}.dbx_object
          where parent_guid is null"
        results.each do |line|
          return_items = return_items.merge( {
            line[2].to_sym => { :name => line[0], :id => line[1], :guid => line[2],
              :object_update_date => line[3], :object_update_user => line[4]
            }
          })
        end
      else
        #path is given, need to traverse and find it to find the guid
        if parent_guid != 0 then
          #guid is given, makes the job a lot easier
          Rails.logger.info "get stuff for guid #{parent_guid}"
          return_items = list_obj repo_name, parent_guid
        else
          Rails.logger.info "can't find guid, need to traverse"
        end
      end

      return return_items
  end

  # returns a hash w/ { :guid => { :property => value, ... }} showing history of the object
  def show_history repo_name, object_guid
    return_items = Hash.new

    if object_guid.empty? or object_guid.nil? then
      return return_items
    end

    results = query "select id from #{repo_name}.dbx_object where guid = '#{object_guid}'"
    object_id = results.first[0]
    results = query "select guid, username, id, operation, endtime, insert_user
      from #{repo_name}.dovhistoryentry
      where object_id = #{object_id}
      order by id desc
      "
    results.each do |line|
      return_items = return_items.merge( {
        line[0].to_sym => { :username => line[1], :id => line[2], :operation => line[3], :endtime => line[4] }
      } )
    end

    return return_items
  end

  #given a repo name and path, gets the child object guid
  def get_guid repo_name, path
      current_layer = path.split("/")[1]

      if current_layer.nil? then
        #already top level
        return nil
      else
        #get the top level guid and traverse
        return get_guid_traverse(repo_name, current_path, nil)
      end
  end

  private

  # returns a hash of :collection_guid => {:collection_name => name, :collection_property => value}
  # given by the parent_guid in the repo
  def list_obj repo_name, parent_guid
    return_items = Hash.new

    results = query "select
      coll.name, coll.id, guid, object_update_date, object_update_user
      from #{repo_name}.dbx_object coll where coll.parent_guid = '#{parent_guid}'"
    results.each do |line|
      return_items = return_items.merge({
        line[2].to_sym => {
          :name => line[0], :id => line[1], :guid => line[2], :object_update_date => line[3], :object_update_user => line[4] }
      })
    end

    return return_items
  end

  def get_guid_traverse repo_name, current_path, parent_guid
  end
end
