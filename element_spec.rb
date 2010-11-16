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

  # states
  # ------

  # checked?

  # enabled?

  # visible?

  # properties
  # ----------

  # tag_name
  # style

end
