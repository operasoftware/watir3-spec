# encoding: utf-8
require File.expand_path("../../watirspec_helper", __FILE__)

describe "Element" do
  #direct attribute access
  before :each do
    browser.goto(fixture('non_control_elements.html'))
    @element = window.strong(:id => "descartes").first
    @list = window.ul(:id => "navbar").first
    @leaf = window.a(:id => "link_2").first
  end

  # parent
  describe "#parent" do
    it "is the parent element of this element" do
      # two .parent to get to an IDed element
      @element.parent.parent.attr(:id).should == "promo"
    end

    it "is nil for the root element" do
      window.html.parent.should == nil
    end
  end

  # children
  describe "#children" do
    it "is not empty when there are child elements" do
      @list.children.should_not be_empty
    end

    it "contains the child elements of this element" do
      @list.children.all? do |child|
        child.parent.attr(:id) == "navbar"
      end.shoud be_true
    end

    it "is empty when the element has no children" do
      @leaf.children.should be_empty
    end
  end

  # attr(what)
  describe "#attr" do
    it "gets the value of the given attribute" do
      @element.attr(:class).should == "descartes"
    end

    it "is nil when the attribute does not exist" do
      @element.attr(:hoobaflooba).should == nil
    end
  end

  # text
  describe "#text" do
    it "is the text contained by the element" do
      @element.text.should == "Dubito, ergo cogito, ergo sum."
    end

    it "is an empty string when there is no text" do
      window.body.children.first.text.should == ""
    end
  end

  # html
  describe "#html" do
    it "is the outer HTML of the element" do
      @element.html.should == '<strong id="descartes" class="descartes">Dubito, <em class="important-class" id="important-id" title="ergo cogito">ergo cogito</em>, ergo sum.</strong>'
    end

    it "is an empty string if the element contains no text or html" do
      window.body.div.first.html.should == ""
    end
  end

  # states
  # ------

  # checked?
  describe "#checked?" do
    before :each do
      browser.goto(fixture('non_control_elements.html'))
      @textbox = window.input(:id => "new_user_username").first
      @checkbox_checked = window.input(:id => "new_user_interests_books").first
      @uncheckbox_checked = window.input(:id => "bowling").first
      @radio_checked = window.input(:id => "new_user_newsletter_yes").first
      @radio_unchecked = window.input(:id => "new_user_newsletter_no").first
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
      @inputs = window.input

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
      window.h1.first.should be_true
    end

    it "is false for an element with style attribute 'display:none'" do
      window.div(:id => "parent").first.visible?.should be_false
    end

    it "is false a child of an element with style attribute 'display:none'" do
      window.div(:id => "child").first.visible?.should be_false
    end

    it "is false for an element hidden by CSS" do
      window.div(:id => "hidden_by_css").first.visible?.should be_false
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

  # tag_name
  # style

end
