require 'net/ldap'
require 'stored_ldap'
require 'devise/strategies/authenticatable'

module Devise
	module Strategies
		class LdapAuthenticatable < Authenticatable
			def authenticate!
				if params[:user]
					ldap = Net::LDAP.new
					ldap.host = ENV['DEVISE_LDAP_HOST']
					ldap.port = 636
					ldap.base = ENV['DEVISE_LDAP_BASE']
					ldap.encryption :simple_tls
					ldap.auth "#{login}@#{params[:user][:domain]}", password
					ldap.auth "#{params[:user][:username]}@#{params[:user][:domain]}", password
					session[:ldapConn] = StoredLDAP.new_connection "#{params[:user][:username]}@#{params[:user][:domain]}", password
					session[:password] = password

					valid_login = false
					in_group = false

					if ldap.bind
						valid_login = true

						#save the ldap session as session variable
						session[:ldap] = ldap.to_yaml

						#find the user
						filter = Net::LDAP::Filter.eq( 'samaccountname', params[:user][:username] )
						search_result = ldap.search( :base => ldap.base , :filter => filter).first

						#check if the user is in the proper group
						if ENV['DEVISE_CHECK_GROUPS'] == 'true' then
							group_search_results = ldap.search( :base => search_result[:dn].first,
								:filter =>
									Net::LDAP::Filter.ex( "memberof:1.2.840.113556.1.4.1941",
										ENV['DEVISE_REQ_GROUPS'], :scope => Net::LDAP::SearchScope_BaseObject) )
							if group_search_results.length == 1 then
								in_group = true
							end
						else
							in_group = true
						end
					else
							session[:ldap] = nil
					end

					if valid_login && in_group then
						#start looking for user or create a new one
						user = User.where(:username => params[:user][:username]).first

						if user.nil? then
							#setup email. some accounts dones't have email
							email = search_result[:mail].first.nil? ?
								"#{params[:user][:username]}@#{params[:user][:domain]}" : search_result[:mail].first
							user = User.new(:username => params[:user][:username],
								:email => email,
								:name => search_result[:displayname].first,
								#:username => search_result[:samaccountname].first,
								:password => params[:user][:password], :domain => params[:user][:domain] )
							user.save!
							params[:user][:email] = email
						else
							user.update_attributes({
								:name => search_result[:displayname].first,
								:password => params[:user][:password], :domain => params[:user][:domain]
							} )
						end

						success!(user)
					else
						#somehow this doesn't work if the user have logon before so blank out username field
						params[:user][:username] = ""
						return fail(:invalid)
					end
				end
			end

			#def email
			#	params[:user][:username] + "@petronas.com.my"
			#end

			def login
				params[:user][:username]
			end

			def password
				params[:user][:password]
			end

			def login
				params[:user][:username]
			end

			def user_data
				login:login
			end
		end
	end
end

Warden::Strategies.add(:ldap_authenticatable, Devise::Strategies::LdapAuthenticatable)
