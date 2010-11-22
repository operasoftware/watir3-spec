# encoding: utf-8
require File.expand_path("../watirspec_helper", __FILE__)

describe 'Browser' do

  before :all do
    browser.url = fixture('simple.html')
  end

  describe '#new' do
    it 'constructs a new instance' do
      browser.exists?.should be_true
      browser.respond_to?('new').should be_true
    end
  end

  describe '#name' do
    # FIXME
    it 'is the name of a Watir implementation' do
      browser.name.size.should > 1
    end
  end

  describe '#url=' do  # goto() is an alias
    it 'opens a new window' do
      new_window = browser.goto fixture('simple.html')
      new_window.exists?.should be_true
    end

    it 'navigates to a url' do
      window.url.should == fixture('simple.html')
    end

    it 'navigates to a url using goto alias' do
      browser.goto fixture('simple.html')
      window.url.should == fixture('simple.html')
    end
  end

  describe '#connected?' do
    it 'checks that the browser is connected' do
      browser.connected?.should be_true
    end

    it 'checks that the browser is connected using #is_connected? alias' do
      browser.is_connected?.should be_true
    end
  end

  describe '#quit' do

    # I'm not sure this can be tested.
    #it 'quits the browser' do
    #  browser.quit
    #  browser.exists?.should be_false
    #end

  end

  describe '#windows' do
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
      browser.windows.length.should == 0
    end

    # TODO: Window selectors

  end

  describe '#version' do
    it 'fetches the version number of the driver' do
      browser.version.should match /\d{1,}\.\d{1,}\.\d{1,}/
    end
  end

  describe '#pid' do
    it 'fetches the PID from the attached browser instance' do
      browser.pid.should be_numeric
      browser.pid.should > 0
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
      browser.build.should be_numeric
      browser.build.should > 0
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

  describe '#exists?' do
    it 'is true if we are attached to a browser' do
      browser.exists?.should be_true
    end

    it 'is false if we are not attached to a browser' do
      browser.close
      browser.exists?.should be_false
    end

    after :all do
      browser = OperaWatir::Waiter.browser
    end
  end

  describe '#desktop?' do
    it 'responds with boolean' do
      browser.desktop?.kind_of?(TrueClass || FalseClass).should be_true
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

  describe '#preferences' do
    before :all do
      # Caches options that we will tamper with.
      @preferences = browser.preferences
    end

    it 'is a list of all preferences' do
      browser.preferences.length.should > 10
    end

    it 'contains options' do
      browser.preferences('Developer Tools', 'Proxy Auto Connect').should_not be_empty
    end

    it 'gets a value of an option' do
      browser.preferences('Cache', 'SVG Cache Size').should be_numeric
      browser.preferences('Cache', 'SVG Cache Size').should > 0
    end

    it 'returns a top block of preferences' do
      browser.preferences.each do |section, option, value|
        section.should_not be_empty
        option.should_not be_empty
      end
    end

    it 'returns a sub block of preferences' do
      browser.preferences('Cache').each do |option, value|
        option.should_not be_empty
      end
    end

    it 'sets an option' do
      browser.preferences('Cache', 'Application Cache Quota').value = 0
      browser.preferences('Cache', 'Application Cache Quota').should == 0
    end

    it 'sets options by a given block' do
      preferences = {
        'Cache' => {
          'Always Check Never-Expiring GET queries' => false,
          'Application Cache Quota' => -5000,
          'SVG Cache Size' => 2000
        }
      }

      browser.preferences = preferences

      browser.preferences('Cache', 'Always Check Never-Expiring GET queries').should_not be_true
      browser.preferences('Cache', 'Application Cache Quota').should == -5000
      browser.preferences('Cache', 'SVG Cache Size').should == 2000

      # Making sure setting block didn't affect any other blocks.
      browser.preferences('Colors', 'Background').should == @preferences['Colors']['Background']
      browser.preferences('Fonts', 'Dialog').should == @preferences['Fonts']['Dialog']
    end

    it 'fetches default value of an option' do
      browser.preferences('Cache', 'SVG Cache Size').default.should > 2000
    end

    it 'resets an option to default' do
      browser.preferences('Cache', 'SVG Cache Size').reset!
      browser.preferences('Cache', 'SVG Cache Size').should == browser.preferences('Cache', 'SVG Cache Size').default
    end

    after :all do
      # Resets options that we've tampered with.
      browser.preferences = @preferences
    end
  end

end
