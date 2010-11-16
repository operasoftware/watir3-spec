# encoding: utf-8
require File.expand_path("../../watirspec_helper", __FILE__)

describe "Window" do

  before :each do
    browser.goto(fixture('images.html'))
  end

  describe "#get_elements_by_id" do

    it "returns an element with the given ID" do
      elements = window.find_elements_by_id("header")

      elements.should_not be_empty
      elements.length.should == 1
      elements.first.id.should == "header"
    end
  end

  describe "#tag" do
    it "is not empty if the tag exists" do
      window.tag(:div).should_not be_empty
    end

    it "contains all elements of the tag name" do
      window.tag(:div).all? do |element|
        element.tag_name == "div"
      end.shoud be_true
    end

    it "is empty if the elements do not exist" do
      window.tag(:hoobaflooba).should be_empty
    end
  end

  # regex's for all!

  # css

  # class

  # xpath

  # tagname

  # click(x,y)

  # element = tagName(*)
end

describe "Browser" do

  #goto(), back(), forward(), version, url, get/set prefs()

end

describe "Collection" do
  before :each do
    browser.goto(fixture('images.html'))
    @collection = window.div
  end

  #direct attribute access

  #element filter

  #find

  #attr

  # stuff like
  #   check, only on checkboxes
  #   enabled, only on "inputs"

end

describe "Element" do
  #direct attribute access

  #attr

  # stuff like
  #   check(), only on checkboxes
  #   enabled?, only on "inputs"
  #   enable()
end
