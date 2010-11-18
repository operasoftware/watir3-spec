# encoding: utf-8
require File.expand_path("../../watirspec_helper", __FILE__)

describe "Browser" do

  #goto(), back(), forward(), version, url, get/set prefs()

  describe "#goto" do
    it "navigates to a url" do
      window.url = "http://example.com/"
      window.url.should == "http://example.com/"
    end
  end

  describe "#windows" do
    it "is not empty" do
      browser.windows.should_not be_empty
    end

    it "is a list of open windows" do
      browser.windows.all? do |window|
        window.respond_to? :get_elements_by_id
      end.should be_true
    end
  end

  describe "#close" do
    it "closes the browser" do
      browser.close()
      browser.exists?.should be_false
    end
  end

  describe "#exists?" do
    it "is true if we are attached to a browser" do
      browser.exists?.should be_true
    end

    it "is false if we are not attached to a browser" do
      browser.close()
      browser.exists?.should be_false
    end
  end

  # configuration
  describe "#speed" do
    it "is one of :fast, :medium or :slow" do
      [:fast, :medium, :slow].any? do |speed|
        browser.speed == speed
      end.should be_true
    end
  end

  describe "#speed=" do
    it "can be set to :fast" do
      browser.speed = :fast
      browser.speed.should == :fast
    end

    it "can be set to :medium" do
      browser.speed = :medium
      browser.speed.should == :medium
    end

    it "can be set to :slow" do
      browser.speed = :slow
      browser.speed.should == :slow
    end

    it "cannot be set to other values" do
      browser.speed = :hoobaflooba
      browser.speed.should_not == :hoobaflooba
    end
  end

end
