# encoding: utf-8
require File.expand_path('../watirspec_helper', __FILE__)

describe 'Collection' do
  before :each do
    browser.goto(fixture('non_control_elements.html'))
    @collection = window.tag(:div)
  end

  # elements
  describe '#id' do
    it 'returns an element with the given ID' do
      elements = @collection.id('header')

      elements.should_not be_empty
      elements.length.should == 1
      elements.first.attr(:id).should == 'header'
    end

    it 'finds multiple elements with the same id' do
      elements = @collection.id('lead')
      elements.length.should == 4
    end
  end

  describe '#tag' do
    it 'is not empty if the tag exists under the collection' do
      @collection.tag(:a).should_not be_empty
    end

    it 'contains all elements of the tag name under the collection' do
      @collection.tag(:a).all? do |element|
        element.tag_name == 'a'
      end.should be_true
    end

    it 'contains only elements restricted by the selector' do
      @collection.tag(:span, :title => 'Lorem ipsum').all? do |element|
        element.attr(:title) == 'Lorem ipsum'
      end.should be_true
    end

    it 'is empty if the elements do not exist' do
      @collection.tag(:hoobaflooba).should be_empty
    end
  end

  # css
  # we don't want a complete CSS selector test suite here, so just some common
  # selectors
  describe '#selector' do
    it 'is not empty if an element matches the css selector' do
      window.selector('ul').should_not be_empty
    end

    it 'contains all elements selected by the selector' do
      collection = window.id('outer_container')
      collection.selector('> div').all? do |element|
        element.parent.attr(:id).should == 'outer_container'
      end.should be_true
    end

    it 'is empty if the selector does not match' do
      @collection.selector('#hoobaflooba').should be_empty
    end
  end

  # class
  describe '#class' do
    it 'is not empty if an element matches the class' do
      @collection.class(:lead).should_not be_empty
    end

    it 'contains all elements with the given class' do
      collection  = window.id('promo')
      @collection.class(:lead).all? do |element|
        (element.attr(:class).should match /lead/ &&
          element.parent.attr(:id).should  == 'promo')
      end.should be_true
    end

    it 'finds elements with multiple classes' do
      collection = window.id('header')
      collection.class(:one).all? do |element|
        (element.attr(:class).should match /one/ &&
          element.parent.parent.parent.attr(:id).should == 'header')
      end.should be_true
    end

    it 'is empty if the class does not match' do
      @collection.class(:hoobaflooba).should be_empty
    end
  end

  # xpath
  describe '#xpath' do
    before :all do
      @headers = @collection.xpath('//h1')
    end

    it 'is not empty if elements matches the class' do
      @headers.should_not be_empty
    end

    it 'contains all elements with the given query' do
      @headers.all? do |element|
        element.tag_name.should match /h1/i
      end
    end

    it 'is empty if the query does not match' do
      @collection.xpath('//hoobaflooba').should be_empty
    end

    it 'finds elements in the current context' do
      links = @collection.xpath('a')
      links.all? do |element|
        element.parent.tag_name.match /div/i
      end.should be_true
    end
  end

  # sugar
  describe 'syntactic sugar' do
    it 'returns all decendants with the given tag' do
      content = window.id('content').first.children
      collection = content.span
      collection.all? do |element|
        child = false

        # check that this element is somewhere under div#content
        until element.parent == nil do
          element = element.parent
          if element.attr(:id) == 'content'
            return true
          end
        end

        return false
      end.should be_true
    end

    it 'can be chained' do
      window.id('promo').ul.li.all? do |element|
        element.tag_name.match(/li/i) && element.parent.tag_name.match(/ul/i)
      end.should be_true
    end

    it 'returns the same as #tag' do
      @collection.span(:title => 'Lorem ipsum').should == @collection.tag(:span, :title => 'Lorem ipsum')
    end

    # This may be unnecessary...
    it 'responds to html elements' do
      [:a,:abbr,:address,:area,:article,:aside,:audio,:b,:base,:bdo,:blockquote,:body,
:br,:button,:canvas,:caption,:cite,:code,:col,:colgroup,:command,:datalist,:dd,
:del,:details,:dfn,:div,:dl,:dt,:em,:embed,:eventsource,:fieldset,:figcaption,
:figure,:footer,:form,:h1,:h2,:h3,:h4,:h5,:h6,:head,:header,:hgroup,:hr,:i,
:iframe,:img,:input,:ins,:kbd,:keygen,:label,:legend,:li,:link,:mark,:map,
:menu,:meta,:meter,:nav,:noscript,:object,:ol,:optgroup,:option,:output,:p,
:param,:pre,:progress,:q,:ruby,:rp,:rt,:samp,:script,:section,:select,:small,
:source,:span,:strong,:style,:sub,:summary,:sup,:table,:tbody,:td,:textarea,
:tfoot,:th,:thead,:time,:title,:tr,:ul,:var,:video,:wbr].all do |symbol|
        @collection.respond_to? symbol
      end.should be_true
    end

  end

  # length
  describe '#length' do
    it 'is the number of items in the collection' do
      @collection.length.should == 12
    end
  end

  describe '#attr' do
    it 'returns the given attribute of the first element' do
      @collection.attr(:id).should == 'outer_container'
    end
  end

  # attrs(what)
  describe 'attrs' do
    it 'returns the attributes of each of the elements in the collection' do
      @collection.attrs(:id)[0].should == 'outer_container'
      @collection.attrs(:id)[1].should == 'header'
      @collection.attrs(:id)[8].should == 'hidden'
    end
  end

  # states
  # ------

  describe '#click!' do
    it 'clicks all the elements in this collection' do
      collection = window.class('footer')
      collection.click!
      collection.all? do |element|
        element.text.match(/Javascript/) != nil
      end.should be_true
    end
  end

  # checked?
  describe '#checked?' do
    before :each do
      browser.goto(fixture('forms_with_input_elements.html'))
      @boxes = window.tag(:input, :type => 'checkbox')
    end

    it 'is false if one of the elements is not checked' do
      @boxes.checked?.should be_false
    end

    it 'is false if one of the elements is not checked' do
      @boxes.each do |box|
        box.check!
      end
      @boxes.checked?.should be_true
    end
  end

  # check!
  describe '#check!' do
    it 'checks all of the checkboxes' do
      browser.goto(fixture('forms_with_input_elements.html'))
      @boxes = window.tag(:input, :type => 'checkbox')

      @boxes.check!
      @boxes.all? do |box|
        box.checked? == true
      end.should be_true
    end
  end

  # uncheck!
  describe '#uncheck!' do
    it 'unchecks all of the checkboxes' do
      browser.goto(fixture('forms_with_input_elements.html'))
      @boxes = window.tag(:input, :type => 'checkbox')

      @boxes.uncheck!
      @boxes.all? do |box|
        box.checked? == false
      end.should be_true
    end
  end

  # toggle_check!
  describe '#toggle_check!' do
    it 'toggles the checked state of all of the checkboxes' do
      browser.goto(fixture('forms_with_input_elements.html'))
      @boxes = window.tag(:input, :type => 'checkbox')

      @boxes.toggle_check!
      @boxes.all? do |box|
        box.checked? == true
      end.should be_true
    end
  end

  # enabled?
  describe '#enabled?' do
    before :each do
      browser.goto(fixture('forms_with_input_elements.html'))
    end

    it 'returns true if all collection elements are enabled' do
      fieldset = window.id('delete_user').first.children.first
      fieldset.children.enabled?.should be_true
    end

    it 'returns false if any collection elements are disabled' do
      fieldset = window.id('new_user').first.children.first
      fieldset.children.enabled?.should be_false
    end
  end

  # enable!
  describe '#enable!' do
    it 'enables all elements in the collection' do
      browser.goto(fixture('forms_with_input_elements.html'))
      fieldset = window.id('delete_user').first.children.first
      fieldset.children.enable!
      window.id('new_user_species').enabled?.should be_true
    end
  end

  # disable!
  describe '#disable' do
    it 'disables all elements in the collection' do
      browser.goto(fixture('forms_with_input_elements.html'))
      fieldset = window.id('delete_user').first.children.first
      fieldset.children.disable!
      fieldset.children.all? do |element|
        element.enabled? == false
      end.should be_true
    end
  end

  # visible?
  describe '#visible' do
    it 'is true if all the elements are visible' do
      window.tag(:ul).visible?.should be_true
    end

    it 'is false if not all elements are visible' do
      @collection.visible?.should be_false
    end
  end
  # show!
  describe '#show!' do
    it 'shows all the elements' do
      @collection.show!
      window.id('hidden').visible?.should be_true
    end
  end

  # hide!
  describe '#hide!' do
    it 'hides all the elements' do
      @collection.hide!
      window.id('outer_container').visible?.should be_false
    end
  end

  # actions
  # -------
end
