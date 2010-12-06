# encoding: utf-8
require File.expand_path('../watirspec_helper', __FILE__)

describe 'Element' do
  # Direct attribute access
  before :each do
    browser.url = fixture('non_control_elements.html')

    @element = window.find_by_id('descartes').first
    @list    = window.find_by_id('navbar').first
    @leaf    = window.find_by_id('link_2').first
  end

  # parent
  describe '#parent' do
    it 'is the parent element of an element' do
      # Two .parent to get to an IDed element
      @element.parent.parent.attr(:id).should == 'promo'
    end

    it 'is nil for the root element' do
      window.tag(:html).first.parent.should == nil
    end
  end

  # attr(what, value=nil)
  describe '#attr' do
    it 'gets the value of the given attribute' do
      @element.attr(:class).should == 'descartes'
    end

    it 'uses underscores instead of dashes' do
      @leaf.attr(:data_fixture).should == 'leaf'
    end

    it 'is nil when the attribute does not exist' do
      @element.attr(:hoobaflooba).should == nil
    end

    it 'sets the attribute value when passed a value' do
      @element.attr(:id => 'value')
      @element.attr(:id).should == 'value'
    end

    it 'sets multiple attributes when passed values' do
      @element.attr(:id => 'one', :class => 'two')
      @element.attr(:id).should == 'one'
      @element.attr(:class).should == 'two'
    end
  end

  describe 'sugar' do
    it 'provides direct access to the element\'s attributes' do
      @element.class.should == @element.attr(:class)
      @element.id.should == @element.attr(:id)
    end

    it 'uses underscores instead of dashes' do
      @leaf.data_fixture.should == 'leaf'
    end

    it 'is nil when the attribute does not exist' do
      @element.hoobaflooba.should be_nil
    end

    it 'allows attributes to be set' do
      @element.class = 'test'
      @element.attr(:class).should == 'test'
      @element.id = 'test'
      @element.attr(:id).should == 'test'

      @leaf.data_fixture = 'test'
      @leaf.attr(:data_fixture).should == 'test'
    end
  end

  # text
  describe '#text' do
    it 'is the text contained by the element' do
      @element.text.should == 'Dubito, ergo cogito, ergo sum.'
    end

    it 'is an empty string when there is no text' do
      window.find_by_tag(:body).div.first.text.should == ''
    end
  end

  describe '#text=' do
    it 'sets the text content of the element' do
      @element.em.first.text = 'test'
      @element.text.should == 'Dubito, test, ergo sum.'
    end

    it 'overwrites child elements' do
      @element.text = 'test'
      @element.em.should be_empty
    end
  end

  # html
  describe '#html' do
    it 'is the outer HTML of the element' do
      @element.html.should == "<strong id='descartes' class='descartes'>Dubito, <em class='important-class' id='important-id' title='ergo cogito'>ergo cogito</em>, ergo sum.</strong>"
    end

    it 'is an empty string if the element contains no text or html' do
      window.tag(:body).div.first.html.should == ''
    end
  end

  describe '#html=' do
    it 'sets the outer HTML of the element' do
      @element.em.first.html = '<b>test</b>'
      @element.html.should == "<strong id='descartes' class='descartes'>Dubito, <b>test</b>, ergo sum.</strong>"
    end

    it 'creates child elements' do
      @element.em.first.html = "<b>one</b> <b class='test'>two</b>"
      @element.em.length.should == 2
      @element.em[1].attr(:class).should == 'test'
    end
  end

  # tag_name
  describe '#tag_name' do
    it 'is the tag name of an element' do
      @element.tag_name.should match /strong/i
      @list.tag_name.should match /ul/i
    end
  end

  # states
  # ------

  # checked?
  describe '#checked?' do
    before :each do
      browser.url = fixture('forms_with_input_elements.html')

      @textbox            = window.find_by_id('new_user_username').first
      @checkbox_checked   = window.find_by_id('new_user_interests_books').first
      @checkbox_unchecked = window.find_by_id('bowling').first
      @radio_checked      = window.find_by_id('new_user_newsletter_yes').first
      @radio_unchecked    = window.find_by_id('new_user_newsletter_no').first
    end

    # TODO 'checked' is available for all <input> and <command>. Change this
    # test?
    it 'exists on radio button elements' do
      @radio_checked.should respond_to :checked?
    end

    it 'exists on checkbox elements' do
      @checkbox_checked.should respond_to :checked?
    end

    it 'does not exist on non-checkbox or radio button elements' do
      @textbox.should_not respond_to :checked?
      @element.should_not respond_to :checked?
    end

    it 'is true if a checkbox is checked' do
      @checkbox_checked.checked?.should be_true
    end

    it 'is false if a checkbox is not checked' do
      @checkbox_unchecked.checked?.should be_false
    end

    it 'is true if a radio button is checked' do
      @radio_checked.checked?.should be_true
    end

    it 'is false if a radio button is not checked' do
      @radio_unchecked.checked?.should be_false
    end
  end

  # enabled?
  describe '#enabled?' do
    before :each do
      browser.url = fixture('non_control_elements.html')
      @inputs = window.tag(:input)
    end

    # 'disabled' attribute is available on quite a few obscure
    # elements. Toss up between limiting to common ones, all html5,
    # all elements that have a .disabled property in Javascript, or
    # all elements
    it 'exists on input elements' do
      @inputs.all? do |input|
        input.respond_to? :enabled?
      end.should be_true
    end
  end

  # visible?
  describe '#visible?' do
    before :each do
      browser.url = fixture('visible.html')
    end

    it 'is true for a visible element' do
      window.tag(:h1).first.visible?.should be_true
    end

    it 'is false for an element with style attribute “display:none”' do
      window.find_by_id('parent').first.visible?.should be_false
    end

    it 'is false a child of an element with style attribute “display:none”' do
      window.find_by_id('child').first.visible?.should be_false
    end

    it 'is false for an element hidden by CSS' do
      window.find_by_id('hidden_by_css').first.visible?.should be_false
    end

    it 'is true for an element with visibility:hidden' do
      window.find_by_id('invisible').first.visible?.should be_true
    end

  end

  # actions
  # -------

  # focus!
  describe '#focus!' do
    before :each do
      browser.url = fixture('forms_with_input_elements.html')
    end

    it 'focuses the element' do
      input = window.find_by_id('new_user_email').first
      input.focus!
      window.type('test')
      input.attr(:value).should == 'test'
    end

    it 'returns false if the element is disabled' do
      input = window.find_by_id('new_user_species').first
      input.focus!.should be_false
    end
  end

  # click!([x, y]) , x,y relative to element top left
  describe '#click!' do
    it 'follows links' do
      window.find_by_id('link_3').first.click!
      window.url.should match /forms_with_input_elements\.html$/
    end

    it 'triggers onclick handlers' do
      div = window.find_by_id('best_language').first
      div.click!
      div.html.should == 'Ruby!'
    end
  end

  # check!
  describe '#check!' do
    before :each do
      browser.url = fixture('forms_with_input_elements.html')
      @checkbox_unchecked = window.find_by_id('bowling').first
      @radio_unchecked = window.find_by_id('new_user_newsletter_no').first
    end

    it 'checks a checkbox' do
      @checkbox_unchecked.check!
      @checkbox_unchecked.checked?.should be_true
    end

    it 'checks a radio button' do
      @radio_unchecked.check!
      @radio_unchecked.checked?.should be_true
    end
  end
  # uncheck!
  describe '#uncheck!' do
    before :each do
      browser.url = fixture('forms_with_input_elements.html')
      @checkbox_checked = window.find_by_id('new_user_interests_books').first
      @radio_checked = window.find_by_id('new_user_newsletter_yes').first
    end

    it 'unchecks a checkbox' do
      @checkbox_checked.uncheck!
      @checkbox_checked.checked?.should be_false
    end

    it 'unchecks a radio button' do
      @radio_checked.uncheck!
      @radio_checked.checked?.should be_false
    end
  end

  # toggle_check!
  describe '#toggle_check!' do
    before :each do
      browser.url = fixture('forms_with_input_elements.html')
      @checkbox_checked = window.find_by_id('new_user_interests_books').first
      @radio_checked = window.find_by_id('new_user_newsletter_yes').first
    end

    it 'toggles a checkbox' do
      @checkbox_checked.toggle_check!
      @checkbox_checked.checked?.should be_false
      @checkbox_checked.toggle_check!
      @checkbox_checked.checked?.should be_true
    end

    it 'does not toggle appear on a radio button' do
      @radio_checked.should_not respond_to :toggle_check!
    end
  end

  # enable!
  describe '#enable!' do
    it 'enables a form element' do
      window.url = fixture('forms_with_input_elements.html')
      disabled = window.find_by_id('new_user_species')
      disabled.enabled?.should be_false
      disabled.enable!
      disabled.enabled?.should be_true
    end
  end
  # disable!
  describe '#enable!' do
    it 'enables a form element' do
      window.url = fixture('forms_with_input_elements.html')
      disabled = window.find_by_id('new_user_email')
      disabled.enabled?.should be_true
      disabled.disable!
      disabled.enabled?.should be_false
    end
  end

  # show!
  describe '#show!' do
    it 'makes the element visible' do
      hidden = window.find_by_id('hidden').first
      hidden.visible?.should be_false
      hidden.show!
      hidden.visible?.should be_true
    end
  end

  # hide!
  describe '#hide!' do
    it 'sets the element to display:none' do
      @element.visible?.should be_true
      hidden.hide!
      hidden.visible?.should be_false
    end
  end

  # attributes
  # ----------

  # style

end
