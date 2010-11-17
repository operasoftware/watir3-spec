# encoding: utf-8
require File.expand_path("../../watirspec_helper", __FILE__)

describe "Browser" do

  #goto(), back(), forward(), version, url, get/set prefs()

  describe "#goto" do
    it "navigates to a url" do
      browser.goto("http://example.com/")
      window.url.should == "http://example.com/"
    end
  end

end
