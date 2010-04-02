	module DzPublic
		@@config = YAML.load_file("#{Rails.root}/config/database.yml")['dz'].clone

		def self.included(base)
			base.establish_connection @@config
			base.connection.emulate_booleans = false
			class << base
			
				def current_db
					connection.current_database
				end

				def change_connection(dbname)
					return false if dbname.blank?
					if connection.current_database != dbname
						@@config['database'] = dbname
				    establish_connection(@@config)
		      end
		      return dbname
		    end

				def reset_connection
					establish_connection(YAML.load_file("#{Rails.root}/config/database.yml")['main'])
				end
		
				def charset
					@@config['charset']
				end

			end
			
			if @@config[:charset] != ActionController::Base.default_charset
				base.columns.each do |column|
					if [:string, :text].include?(column.type.to_sym)
						base.send :define_method, column.name.to_sym do
							Iconv.conv(ActionController::Base.default_charset, @@config['charset'], read_attribute(column.name))
						end

						base.send :define_method, "#{column.name}=".to_sym do |val|
							write_attribute column.name.to_sym, Iconv.conv(@@config['charset'], ActionController::Base.default_charset, val)
						end
						
					end
				end
			end
			
		end

	end
