module StoredLDAP
	@@ldap_handle = Hash.new

	def self.new_connection username, password
		ldap = Net::LDAP.new
		ldap.host = ENV['DEVISE_LDAP_HOST']
		ldap.port =  636
		ldap.base = ENV['DEVISE_LDAP_BASE']
		ldap.encryption :simple_tls
		ldap.auth username, password
		ldap.bind

		#id = SecureRandom.hex.to_s
		#@@ldap_handle[id] = SecureRandom.hex
		return ldap
	end

	def self.retrive_connection ldap_id
		return  @@ldap_handle[ldap_id]
	end

	def self.dump
		@@ldap_handle.each do |key,value|
			puts "#{key}: #{value}"
		end
	end

	def self.query username, password , query
		#stupid because you have to login everytime to do a search, but will do for now
		ldap = self.new_connection username, password
		displayname = Net::LDAP::Filter.begins('displayname', query)
		mail = Net::LDAP::Filter.begins('mail', query)
		mustperson = Net::LDAP::Filter.eq('objectcategory', 'person')
		#email = Net::LDAP::Filter.begins('mail', query)

		return ldap.search(
			:base => ENV['DEVISE_LDAP_BASE'], :filter => (displayname | mail ) & mustperson
		).map{ |x|
			{
				:displayname => x[:displayname], :samaccountname => x[:samaccountname],
				:mail => (x[:mail].empty? ? x[:userprincipalname].map{|x| x.downcase } : x[:mail])
			}
		}.flatten
	end
end
