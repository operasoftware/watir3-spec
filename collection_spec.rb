# encoding: utf-8
require File.expand_path("../watirspec_helper", __FILE__)

describe "Collection" do
  before :each do
    browser.goto(fixture('non_control_elements.html'))
    @collection = window.get_elements_by_tag(:div)
  end

  # elements
  describe "#get_elements_by_tag" do
    it "is not empty if the tag exists under the collection" do
      @collection.get_elements_by_tag(:a).should_not be_empty
    end

    it "contains all elements of the tag name under the collection" do
      @collection.get_elements_by_tag(:a).all? do |element|
        element.tag_name == "a"
      end.should be_true
    end

    it "contains only elements restricted by the selector" do
      window.get_elements_by_tag(:span, :title => "Lorem ipsum").all? do |element|
        element.attr(:title) == "Lorem ipsum"
      end.should be_true
    end

    it "is empty if the elements do not exist" do
      window.get_elements_by_tag(:hoobaflooba).should be_empty
    end
  end

  # length
  describe "#length" do
    it "the number of items in the collection" do
      @collection.length.should == 12
    end
  end

  describe "#attr" do
    it "returns the given attribute of the first element" do
      @collection.attr(:id).should == "outer_container"
    end
  end

  # attrs(what)
  describe "attrs" do
    it "returns the attributes of each of the elements in the collection" do
      @collection.attrs(:id)[0].should == "outer_container"
      @collection.attrs(:id)[1].should == "header"
      @collection.attrs(:id)[8].should == "hidden"
    end
  end

  # states
  # ------

  # checked?
  # check!
  # uncheck!
  # toggle_check!

  # enabled?
  # enable!
  # disable!

  # visible?
  # show!
  # hide!

  # actions
  # -------
end
