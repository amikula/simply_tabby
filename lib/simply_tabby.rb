require 'rubygems'
require 'socket'
require 'ezcrypto'

class SimplyTabby

  REVISION_FILE = File.join(File.dirname(__FILE__), '../../../../', 'REVISION')
  PASS_PHRASE   = "xx"
  SALT          = "xx"
  
  ##
  # Rails revision.
  def self.revision_number
    File.exist?(REVISION_FILE) ? File.open(REVISION_FILE).readline.chomp : "No revision found"
  end

  ##
  # Return the data structure.  
  def self.display_system_information
    @@data
  end
  
  def self.display_crypt_system_information
    EzCrypto::Key.with_password(PASS_PHRASE, SALT).encrypt64(@@data[:crypt].map { |k, v|  "#{k}: #{v}\n"}.join) rescue nil
  end

  ##
  # Remove a key from the hash.
  def self.remove_system_information(type, *args)
    args.each { |s| @@data[type].delete(s) }
  end

  ##
  # Add additional system information to the hash.
  def self.add_system_information(type, opts={})
    @@data[type].merge!(opts)
  end

  ##
  # Create the data structure.
  @@data = {
    :public => {
      :application_revision => self.revision_number,
      :environment => RAILS_ENV
    },
    :crypt => {
      :database_adapter => (ActiveRecord::Base.configurations[RAILS_ENV]['adapter'] rescue nil),
      :database_schema_version => (ActiveRecord::Migrator.current_version rescue nil),
      :hostname => Socket.gethostname,
      :rails_version => Rails::VERSION::STRING,
      :ruby_platfom => RUBY_PLATFORM,
      :ruby_version => RUBY_VERSION,
      :rubygems_version => Gem::RubyGemsVersion
    }
  }

end
