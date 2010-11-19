# encoding: utf-8
require File.expand_path("../watirspec_helper", __FILE__)

describe "Element" do
  #direct attribute access
  before :each do
    browser.goto(fixture('non_control_elements.html'))
    @element = window.get_elements_by_id("descartes").first
    @list = window.get_elements_by_id("navbar").first
    @leaf = window.get_elements_by_id("link_2").first
  end

  # parent
  describe "#parent" do
    it "is the parent element of an element" do
      # two .parent to get to an IDed element
      @element.parent.parent.attr(:id).should == "promo"
    end

    it "is nil for the root element" do
      window.get_elements_by_tag(:html).first.parent.should == nil
    end
  end

  # children
  describe "#children" do
    it "is not empty when there are child elements" do
      @list.children.should_not be_empty
    end

    it "contains the child elements of an element" do
      @list.children.all? do |child|
        child.parent.attr(:id) == "navbar"
      end.should be_true
    end

    it "is empty when the element has no children" do
      @leaf.children.should be_empty
    end
  end

  # attr(what, value=nil)
  describe "#attr" do
    it "gets the value of the given attribute" do
      @element.attr(:class).should == "descartes"
    end

    it "is nil when the attribute does not exist" do
      @element.attr(:hoobaflooba).should == nil
    end

    it "sets the attribute value when passed a value" do
      @element.attr(:id => "value")
      @element.attr(:id).should == "value"
    end
  end

  # text
  describe "#text" do
    it "is the text contained by the element" do
      @element.text.should == "Dubito, ergo cogito, ergo sum."
    end

    it "is an empty string when there is no text" do
      window.get_elements_by_tag(:body).first.children.first.text.should == ""
    end
  end

  describe "#text=" do
    it "sets the text content of the element" do
      @element.children.first.text = "test"
      @element.text.should == "Dubito, test, ergo sum."
    end

    it "overwrites child elements" do
      @element.text = "test"
      @element.children.should be_empty
    end
  end

  # html
  describe "#html" do
    it "is the outer HTML of the element" do
      @element.html.should == '<strong id="descartes" class="descartes">Dubito, <em class="important-class" id="important-id" title="ergo cogito">ergo cogito</em>, ergo sum.</strong>'
    end

    it "is an empty string if the element contains no text or html" do
      window.get_elements_by_tag(:body).first.children.first.html.should == ""
    end
  end

  describe "#html=" do
    it "sets the outer HTML of the element" do
      @element.children.first.html = '<b>test</b>'
      @element.html.should == '<strong id="descartes" class="descartes">Dubito, <b>test</b>, ergo sum.</strong>'
    end

    it "creates child elements" do
      @element.children.first.html = '<b>one</b> <b class="test">two</b>'
      @element.children.length.should == 2
      @element.children[1].attr(:class).should == "test"
    end
  end

  # tag_name
  describe "#tag_name" do
    it "is the tag name of an element" do
      @element.tag_name.should == "strong"
      @list.tag_name.should == "ul"
    end
  end

  # states
  # ------

  # checked?
  describe "#checked?" do
    before :each do
      browser.goto(fixture('non_control_elements.html'))
      @textbox = window.get_elements_by_id("new_user_username").first
      @checkbox_checked = window.get_elements_by_id("new_user_interests_books").first
      @uncheckbox_checked = window.get_elements_by_id("bowling").first
      @radio_checked = window.get_elements_by_id("new_user_newsletter_yes").first
      @radio_unchecked = window.get_elements_by_id("new_user_newsletter_no").first
    end

    # TODO "checked" is available for all <input> and <command>. Change this
    # test?
    it "exists on radio button elements" do
      @radio_checked.should respond_to :checked?
    end

    it "exists on checkbox elements" do
      @checkbox_checked.should respond_to :checked?
    end

    it "does not exist on non-checkbox or radio button elements" do
      @textbox.should_not respond_to :checked?
      @element.should_not respond_to :checked?
    end

    it "is true if a checkbox is checked" do
      @checkbox_checked.checked?.should be_true
    end

    it "is false if a checkbox is not checked" do
      @checkbox_unchecked.checked?.should be_false
    end

    it "is true if a radio button is checked" do
      @radio_checked.checked?.should be_true
    end

    it "is false if a radio button is not checked" do
      @radio_unchecked.checked?.should be_false
    end
  end

  # enabled?
  describe "#enabled?" do
    before :each do
      browser.goto(fixture('non_control_elements.html'))
      @inputs = window.get_elements_by_tag(:input)
    end

    # "disabled" attribute is available on quite a few obscure elements. Toss
    # up between limiting to common ones, all html5, all elements that have a
    # .disabled property in Javascript, or all elements
    it "exists on input elements" do
      @inputs.all? do |input|
        input.respond_to? :enabled?
      end.should be_true
    end
  end

  # visible?
  # NOTE should this be false for "visibility: hidden"?
  describe "#visible?" do
    before :each do
      browser.goto(fixture("display.html"))
    end

    it "is true for a visible element" do
      window.get_elements_by_tag(:h1).first.visible?.should be_true
    end

    it "is false for an element with style attribute 'display:none'" do
      window.get_elements_by_id("parent").first.visible?.should be_false
    end

    it "is false a child of an element with style attribute 'display:none'" do
      window.get_elements_by_id("child").first.visible?.should be_false
    end

    it "is false for an element hidden by CSS" do
      window.get_elements_by_id("hidden_by_css").first.visible?.should be_false
    end

  end

  # actions
  # -------

  # click!([x, y]) , x,y relative to element top left

  # check!
  # uncheck!
  # toggle_check!

  # enable!
  # disable!

  # show!
  # hide!

  # attributes
  # ----------

  # style

end
