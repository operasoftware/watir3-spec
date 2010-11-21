# encoding: utf-8
require File.expand_path("../watirspec_helper", __FILE__)

describe 'Browser' do

  before :all do
    browser.url = fixture('simple.html')
  end

  #url(), back(), forward(), version, url, get/set prefs()

#  describe '#new' do
#    it 'constructs a new instance' do
#      new_browser = OperaWatir::Browser.new
#      new_browser.exists?.should be_true
#    end
#  end

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

  describe '#windows' do
    it 'is not empty' do
      browser.windows.should_not be_empty
    end

    it 'is a list of open windows' do
      browser.windows.all? do |window|
        window.respond_to? :find_elements_by_id
      end.should be_true
    end

    # TODO: Window selectors

  end

  describe '#close' do
    it 'closes the browser' do
      browser.close
      browser.exists?.should be_false
    end
  end

  describe '#exists?' do
    it 'is true if we are attached to a browser' do
      browser.exists?.should be_true
    end

    it 'is false if we are not attached to a browser' do
      browser.close()
      browser.exists?.should be_false
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
    end

    it 'fetches default value of an option' do
      browser.preferences('Cache', 'SVG Cache Size').reset.should > 2000
    end

    it 'resets an option to default' do
      browser.preferences('Cache', 'SVG Cache Size').reset!
    end

    after :all do
      # Resets options that we've tampered with.
      browser.preferences = @preferences
    end
  end

end
