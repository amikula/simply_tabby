require File.join(File.dirname(__FILE__), 'spec_helper')

describe SimplyTabby do
  describe "revision_number class method" do
    it "should return revision number" do
      @file = mock('file')
      File.should_receive(:exist?).and_return(true)
      File.should_receive(:open).and_return(@file)
      @file.should_receive(:readline).and_return('r123')
      SimplyTabby.revision_number.should be_eql('r123')
    end

    it "should _not return revision number" do
      File.should_receive(:exist?).and_return(false)
      SimplyTabby.revision_number.should be_eql('No revision found')
    end
  end

  describe "display_system_information class method" do
    it "should display system information and return a hash" do
      SimplyTabby.display_system_information.should be_an_instance_of(Hash)
    end
  end

  describe "display_crypt_system_information class method" do
    it "should display crypt system information and return a crypt" do
      SimplyTabby.display_crypt_system_information.should be_an_instance_of(String)
    end

    it "returns nil if ezcrypto is not installed" do
      begin
        old_crypto = SimplyTabby::NO_CRYPTO
        without_warnings do
          SimplyTabby::NO_CRYPTO = true
        end

        SimplyTabby.display_crypt_system_information.should be_nil
      ensure
        SimplyTabby::NO_CRYPTO = old_crypto
      end
    end
  end

  describe "reload object" do
    before(:each) do
      ### Force a reload of SimplyTabby class, since our setters modify class variables.
      Object.send(:remove_const, 'SimplyTabby')
      load File.join(File.dirname(__FILE__), '../lib', 'simply_tabby.rb')
    end

    describe "remove_system_information class method" do
      it "should remove one element and return public(hash.keys - 1)" do
        SimplyTabby.display_system_information[:public].should have_key(:application_revision)
        SimplyTabby.remove_system_information(:public, :application_revision)
        SimplyTabby.display_system_information[:public].should_not have_key(:application_revision)
      end
    end

    load File.join(File.dirname(__FILE__), '../lib', 'simply_tabby.rb')
    describe "add_system_information class method" do
      it "should add one element and return public(hash.keys + 1)" do
        SimplyTabby.display_system_information[:public].should_not have_key(:foo)
        SimplyTabby.add_system_information(:public, :foo => 1)
        SimplyTabby.display_system_information[:public].should have_key(:foo)
      end
    end
  end

  describe :do_tell do
    it 'does not raise an exception when display_crypt_system_information is nil' do
      SimplyTabby.should_receive(:display_crypt_system_information).and_return(nil)

      lambda{SimplyTabby.do_tell}.should_not raise_error
    end
  end
end
