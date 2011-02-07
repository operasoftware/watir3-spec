# encoding: utf-8
require File.expand_path('../watirspec_helper', __FILE__)

describe 'Browser' do

  before :all do
    browser.url = fixture('simple.html')
  end

  describe '#new' do
    it 'constructs a new instance' do
      browser.exists?.should be_true
    end
  end

  describe '#driver' do
    it 'returns driver object' do
      browser.driver.instance_of?(Java::ComOperaCoreSystems::OperaDriver).should be_true
    end

    it 'can access native driver methods' do
      browser.driver.getCurrentUrl.should_not be_empty
    end
  end

  describe '#name' do
    # FIXME
    it 'is the name of a Watir implementation' do
      browser.name.should_not be_empty
    end
  end

  describe '#url=' do  # goto() is an alias
    it 'opens a new window' do
      new_window = browser.url fixture('simple.html')
      new_window.exists?.should be_true
      new_window.close
    end

    it 'navigates to a url' do
      window.url = fixture('simple.html')
      window.url.should == fixture('simple.html')
    end

    it 'navigates to a url using goto alias' do
      browser.goto fixture('simple.html')
      browser.active_window.url.should == fixture('simple.html')
    end
  end

  describe '#quit' do
    before :each do
      browser.quit
    end

    it 'quits the browser' do
      browser.connected?.should be_false
    end

    it 'window is closed upon quit' do
      browser.active_window.exists?.should be_false
    end

    it 'windows are closed upon quit' do
      browser.windows.all? do |window|
        window.exists? == false
      end.should be_true
    end

    it 'is not possible to access window properties after quit' do
      # FIXME
      browser.active_window.url.should raise_error NativeException
      browser.active_window.title.should raise_error NativeException
    end

    after :all do
#      OperaWatir::Helper.reconnect
    end
  end

=begin
  describe '#windows' do
    before :all do
      puts 'AFTER QUIT!'
#      browser = OperaWatir::Browser.new
      puts "URL IS NOW: #{browser.active_window.url}"
    end


    it 'is not empty' do
      browser.windows.should_not be_empty
    end

    it 'is a list of open windows' do
      browser.windows.all? do |window|
        window.respond_to? :find_elements_by_id
      end.should be_true
    end

    it 'will close all open windows' do
      open_windows = browser.windows.length
      browser.windows.close_all
      browser.windows.length.should < open_windows
      browser.windows.length.should_not be_zero
    end

    # TODO: Window selectors

  end
=end

  describe '#version' do
    it 'fetches the version number of the driver' do
      browser.version.should match /\d{1,}\.\d{1,}\.\d{1,}/
    end
  end

  describe '#pid' do
    it 'fetches the PID from the attached browser instance' do
      browser.pid.should be_integer
      browser.pid.should_not be_zero
    end
  end

  describe '#platform' do
    it 'fetches the platform the browser is running on' do
      # TODO: Improve regexp
      browser.platform.should match /linux|windows|mac os x|bsd/i
    end
  end

  describe '#build' do
    it 'fetches the build number of the attached browser instance' do
      browser.build.should be_integer
      browser.build.should_not be_zero
    end
  end

  describe '#path' do
    it 'fetches the full path to the binary of the attached browser' do
      # TODO: Improve regexp
      browser.path.should match /(\/|\\){2,}/
    end
  end

  describe '#ua_string' do
    it 'fetches the UA string of the browser' do
      browser.ua_string.should_not be_empty
    end
  end

  describe '#connected?' do
    it 'is attached to a browser instance' do
      browser.connected?.should be_true
    end

    it 'is not attached to a browser instance' do
      browser.quit
      browser.connected?.should be_false
    end
  end

  describe '#desktop?' do
    it 'responds with boolean' do
      (!!browser.desktop? == browser.desktop?).should be_true
    end
  end

  # configuration
  describe '#speed' do
    it 'is one of :fast, :medium or :slow' do
      [:fast, :medium, :slow].any? do |speed|
        browser.speed == speed
      end.should be_true
    end
  end

  describe '#speed=' do
    it 'can be set to :fast' do
      browser.speed = :fast
      browser.speed.should == :fast
    end

    it 'can be set to :medium' do
      browser.speed = :medium
      browser.speed.should == :medium
    end

    it 'can be set to :slow' do
      browser.speed = :slow
      browser.speed.should == :slow
    end

    it 'cannot be set to other values' do
      browser.speed = :hoobaflooba
      browser.speed.should_not == :hoobaflooba
    end
  end

end
