# encoding: utf-8
require File.expand_path('../watirspec_helper', __FILE__)

describe 'Collection' do
  before :each do
    browser.url = fixture('non_control_elements.html')
    @collection = window.find_by_tag(:div)
  end

  # elements
  describe '#find_by_id' do
    it 'returns an element with the given ID' do
      elements = @collection.find_by_id('header')

      elements.should_not be_empty
      elements.length.should == 1
      elements.first.attr(:id).should == 'header'
    end

    it 'finds multiple elements with the same id' do
      elements = @collection.find_by_id('lead')
      elements.length.should == 4
    end
  end

  describe '#find_by_tag' do
    it 'is not empty if the tag exists under the collection' do
      @collection.find_by_tag(:a).should_not be_empty
    end

    it 'contains all elements of the tag name under the collection' do
      @collection.find_by_tag(:a).all? do |element|
        element.find_by_tag_name == 'a'
      end.should be_true
    end

    it 'contains only elements restricted by the selector' do
      @collection.find_by_tag(:span, :title => 'Lorem ipsum').all? do |element|
        element.attr(:title) == 'Lorem ipsum'
      end.should be_true
    end

    it 'is empty if the elements do not exist' do
      @collection.find_by_tag(:hoobaflooba).should be_empty
    end
  end

  # css
  # we don't want a complete CSS selector test suite here, so just some common
  # selectors
  describe '#find_by_css' do
    it 'is not empty if an element matches the css selector' do
      window.find_by_css('ul').should_not be_empty
    end

    it 'contains all elements selected by the selector' do
      collection = window.find_by_id('outer_container')
      divs = collection.find_by_css('> div')
      divs.length.should == 5
      divs[1].id.should == 'outer_container'
      divs[4].id.should == 'del_tag_test'
    end

    it 'is empty if the selector does not match' do
      @collection.find_by_css('#hoobaflooba').should be_empty
    end
  end

  # class
  describe '#find_by_class' do
    it 'is not empty if an element matches the class' do
      @collection.find_by_class(:lead).should_not be_empty
    end

    it 'contains all elements with the given class' do
      collection  = window.find_by_id('promo')
      leads = @collection.find_by_class(:lead)
      leads.length.should == 4
      leads.all? do |element|
        element.attr(:class).should match /lead/
      end.should be_true

    end

    it 'finds elements with multiple classes' do
      collection = window.find_by_id('header')
      collection.find_by_class(:one).all? do |element|
        (element.attr(:class).should match /one/ &&
          element.parent.parent.parent.attr(:id).should == 'header')
      end.should be_true
    end

    it 'is empty if the class does not match' do
      @collection.find_by_class(:hoobaflooba).should be_empty
    end
  end

  # xpath
  describe '#find_by_xpath' do
    before :all do
      @headers = @collection.find_by_xpath('//h1')
    end

    it 'is not empty if elements matches the class' do
      @headers.should_not be_empty
    end

    it 'contains all elements with the given query' do
      @headers.all? do |element|
        element.find_by_tag_name.should match /h1/i
      end
    end

    it 'is empty if the query does not match' do
      @collection.find_by_xpath('//hoobaflooba').should be_empty
    end

    it 'finds elements in the current context' do
      links = @collection.find_by_xpath('a')
      links.all? do |element|
        element.parent.find_by_tag_name.match /div/i
      end.should be_true
    end
  end

  # sugar
  describe 'syntactic sugar' do
    it 'returns all descendants with the given tag' do
      content = window.find_by_id('promo').span
      content.length.should == 5
    end

    it 'can be chained' do
      window.find_by_id('promo').ul.li.all? do |element|
        element.find_by_tag_name.match(/li/i) && element.parent.find_by_tag_name.match(/ul/i)
      end.should be_true
    end

    it 'can be chained deeply;' do
      window.body.div.div.ul.li.a.id.should == ['link_2', 'link_3']
    end

    it 'returns the same as #tag' do
      @collection.span(:title => 'Lorem ipsum').should == @collection.find_by_tag(:span, :title => 'Lorem ipsum')
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

  # item access
  describe '#[]' do
    it 'accesses the elements in the collection' do
      @collection[5].attr(:id).should == "best_language"
      @collection[@collection.length-1].should == "del_tag_test"
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

  # id
  describe '#id' do
    it 'is the id attribute if there is one element' do
      window.find_by_class("primary").id.should == "first_header"
    end

    it 'is nil if the single element has no id' do
      window.find_by_class("php").id.should == nil
    end

    it 'is an array of ids if there is more than one element' do
      window.find_by_class("external").id.should == ["link_2", "link_3"]
    end
  end

  # class
  # TODO this is the class attribute, so it could have multiple classes, in
  # which case this name doesn't make much sense
  describe '#class_name' do
    it 'is the class attribute if there in one element' do
      window.find_by_id("favorite_compounds").class_name.should == "chemistry"
    end

    it 'is nil if the single element has no class' do
      window.find_by_id("outer_container").class_name.should == nil
    end

    it 'is an array of class attributes if there is more than one element' do
      window.find_by_id(/link_[0-9]/).class_name.should == [
        'external one two', 'external'
      ]
    end

    it 'is an array with nil elements when the elements have no class' do
      window.find_by_tag("a").class_name.should == [
        nil, 'external one two', 'external', nil
      ]
    end
  end

  describe '#tag_name' do
    it 'is the tag name if there is one element' do
      window.find_by_id('header4').tag_name.should == 'h4'
    end

    it 'is an array if there are more than one elements' do
      window.find_by_class('lead').tag_name.should == ['span', 'p', 'ins', 'del']
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
      browser.url = fixture('forms_with_input_elements.html')
      @boxes = window.find_by_tag(:input, :type => 'checkbox')
    end

    it 'is true if all of the elements are checked' do
      @boxes.each do |box|
        box.check!
      end
      @boxes.checked?.should be_true
    end

    it 'is false if one of the elements is not checked' do
      @boxes.checked?.should be_false
    end
  end

  # check!
  describe '#check!' do
    it 'checks all of the checkboxes' do
      browser.url = fixture('forms_with_input_elements.html')
      @boxes = window.find_by_tag(:input, :type => 'checkbox')

      @boxes.check!
      @boxes.all? do |box|
        box.checked? == true
      end.should be_true
    end
  end

  # uncheck!
  describe '#uncheck!' do
    it 'unchecks all of the checkboxes' do
      browser.url = fixture('forms_with_input_elements.html')
      @boxes = window.find_by_tag(:input, :type => 'checkbox')

      @boxes.uncheck!
      @boxes.all? do |box|
        box.checked? == false
      end.should be_true
    end
  end

  # toggle_check!
  describe '#toggle_check!' do
    it 'toggles the checked state of all of the checkboxes' do
      browser.url = fixture('forms_with_input_elements.html')
      @boxes = window.find_by_tag(:input, :type => 'checkbox')

      # Store the initial values
      values = @boxes.map { |el| el.checked? }

      @boxes.toggle_check!

      # Check they've all changed
      (0..values.size-1).all do |i|
        @boxes[i].checked? == !values[i]
      end.should be_true
    end
  end

  # enabled?
  describe '#enabled?' do
    before :each do
      browser.url = fixture('forms_with_input_elements.html')
    end

    it 'returns true if all collection elements are enabled' do
      window.find_by_id('delete_user').fieldset.first.option.enabled? should be_true
    end

    it 'returns false if any collection elements are disabled' do
      window.find_by_id('new_user').input.enabled?.should be_false
    end
  end

  # enable!
  describe '#enable!' do
    it 'enables all elements in the collection' do
      browser.url = fixture('forms_with_input_elements.html')
      window.find_by_id('new_user').input.enable!
      window.find_by_id('new_user_species').first.enabled?.should be_true
    end
  end

  # disable!
  describe '#disable' do
    it 'disables all elements in the collection' do
      browser.url = fixture('forms_with_input_elements.html')
      window.find_by_id('new_user').input.disable!
      window.find_by_id('new_user_species').input.any? do |element|
        element.enabled?
      end.should be_false
    end
  end

  # visible?
  describe '#visible' do
    it 'is true if all the elements are visible' do
      window.find_by_tag(:ul).visible?.should be_true
    end

    it 'is false if not all elements are visible' do
      @collection.visible?.should be_false
    end
  end
  # show!
  describe '#show!' do
    it 'shows all the elements' do
      @collection.show!
      window.find_by_id('hidden').visible?.should be_true
    end
  end

  # hide!
  describe '#hide!' do
    it 'hides all the elements' do
      @collection.hide!
      window.find_by_id('outer_container').visible?.should be_false
    end
  end
end
