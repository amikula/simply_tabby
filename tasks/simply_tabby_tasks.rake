require File.join(File.dirname(__FILE__), '../lib/simply_tabby')

unless SimplyTabby::NO_CRYPTO

  namespace :tabby do

    task :setup do
      ##
      # Requires.
      require 'ezcrypto'
      
      puts "INFO: Paste key -- terminate with '^D'"
      @crypt_data = String.new
      for line in STDIN.readlines do
        @crypt_data += line
      end    
    end
      
    desc "Decrypts a given Crypt::TEA.encrypt object."
    task :decrypt => [:setup, :environment ] do |cmd|
      puts "=" * 80
      puts EzCrypto::Key.with_password(SimplyTabby::PASS_PHRASE, SimplyTabby::SALT).decrypt64(@crypt_data)
    end

  end

end
