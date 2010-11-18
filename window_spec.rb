# encoding: utf-8
require File.expand_path("../../watirspec_helper", __FILE__)

describe "Window" do

  before :each do
    browser.goto(fixture('non_control_elements.html'))
  end

  # element access
  # --------------

  describe "#get_elements_by_id" do

    it "returns an element with the given ID" do
      elements = window.find_elements_by_id("header")

      elements.should_not be_empty
      elements.length.should == 1
      elements.first.attr(:id).should == "header"
    end
  end

  describe "#get_elements_by_tag" do
    it "is not empty if the tag exists" do
      window.get_elements_by_tag(:div).should_not be_empty
    end

    it "contains all elements of the tag name" do
      window.get_elements_by_tag(:div).all? do |element|
        element.tag_name == "div"
      end.should be_true
    end

    it "contains only elements restricted by the selector" do
      window.get_elements_by_tag(:div, :title => "Lorem ipsum").all? do |element|
        element.attr(:title) == "Lorem ipsum"
      end.should be_true
    end

    it "is empty if the elements do not exist" do
      window.get_elements_by_tag(:hoobaflooba).should be_empty
    end
  end

  # css
  # we don't want a complete CSS selector test suite here, so just some common
  # selectors
  describe "#get_elements_by_css" do
    it "is not empty if an element matches the css selector" do
      window.get_elements_by_css("#outer_container > div").should_not be_empty
    end

    it "contains all elements selected by the selector" do
      window.get_elements_by_css("#outer_container > div").all? do |element|
        element.parent.attr(:id).should == "outer_container"
      end.should be_true
    end

    it "is empty if the selector does not match" do
      window.get_elements_by_css("#hoobaflooba").should be_empty
    end
  end

  # class
  describe "#get_elements_by_class" do
    it "is not empty if an element matches the class" do
      window.get_elements_by_class(:lead).should_not be_empty
    end

    it "contains all elements with the given class" do
      window.get_elements_by_class(:lead).all? do |element|
        element.attr(:class).should match /lead/
      end.should be_true
    end

    it "gets elements with multiple classes" do
      window.get_elements_by_class(:one).all? do |element|
        element.attr(:class).should match /one/
      end.should be_true
    end

    it "is empty if the class does not match" do
      window.get_elements_by_class(:hoobaflooba).should be_empty
    end
  end

  # xpath

  # tagname

  # click(x,y)

  # all
end
