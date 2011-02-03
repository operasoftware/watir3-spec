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
      window.find_by_tag(:html).first.parent.should == nil
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
  end

  describe 'sugar' do
    it 'provides direct access to the element\'s attributes' do
      @element.id.should == @element.attr(:id)
      @element.class_name.should == @element.attr(:class)
      @element.title.should == @element.attr(:title)
    end

    it 'uses underscores instead of dashes' do
      @leaf.data_fixture.should == 'leaf'
    end

    it 'is nil when the attribute does not exist' do
      @element.hoobaflooba.should be_nil
    end
  end

  # text
  describe '#text' do
    it 'is the text contained by the element' do
      @element.text.should == 'Dubito, ergo cogito, ergo sum.'
    end

    it 'is an empty string when there is no text' do
      window.find_by_tag(:div).first.text.should == ''
    end
  end

  describe '#text=' do
    it 'sets the text content of the element' do
      window.find_by_tag(:em).first.text = 'test'
      @element.text.should == 'Dubito, test, ergo sum.'
    end

    it 'overwrites child elements' do
      @element.text = 'test'
      window.find_by_tag(:em).should be_empty
    end
  end

  # html
  describe '#html' do
    it 'is the outer HTML of the element' do
      @element.html.should == "<strong id='descartes' class='descartes'>Dubito, <em class='important-class' id='important-id' title='ergo cogito'>ergo cogito</em>, ergo sum.</strong>"
    end

    it 'is an empty string if the element contains no text or html' do
      window.find_by_tag(:body).div.first.html.should == ''
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

  # hash
  describe '#visual_hash' do
    it 'is the MD5 hash of the screenshot of the element' do
      window.url = fixture('images.html')
      # this hash is from from Watir 1
      image = window.find_by_tag(:img)[1].visual_hash.should == '0x45688373bcf08d9ecf111ecb2bcb7c4e'
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
      @checkbox_unchecked = window.find_by_id('new_user_interests_cars').first
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

  describe '#selected?' do
    before :each do
      browser.url = fixture('forms_with_input_elements.html')
      @options = window.find_by_id('new_user_country').option
    end

    it 'is true if an option is selected' do
      @options[1].selected?.should be_true
    end

    it 'is false is an option is not selected' do
      @options[5].selected?.should be_false
    end

    it 'is true for multiple selected options' do
      multi = window.find_by_id('new_user_languages').option
      multi[1].selected?.should be_true
      multi[2].selected?.should be_true
    end

    it 'is false for unselected in a multiple select' do
      multi = window.find_by_id('new_user_languages').option
      multi[0].selected?.should be_false
      multi[3].selected?.should be_false
    end

    it 'is nil on non-option elements' do
      @element.selected?.should be_nil
    end
  end

  # enabled?
  describe '#enabled?' do
    before :each do
      browser.url = fixture('forms_with_input_elements.html')
      @inputs = window.find_by_tag(:input)
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
      window.find_by_tag(:h1).first.visible?.should be_true
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

  # click([x, y]) , x,y relative to element top left
  describe '#click' do
    it 'follows links' do
      window.find_by_id('link_3').first.click
      window.url.should match /forms_with_input_elements\.html$/
    end

    it 'triggers onclick handlers' do
      div = window.find_by_id('best_language').first
      div.click
      div.text.should == 'Ruby!'
    end

    it 'toggles checkboxes' do
      browser.url = fixture('forms_with_input_elements.html')
      checkbox = window.find_by_id('new_user_interests_cars').first
      checkbox.checked?.should be_false
      checkbox.click
      checkbox.checked?.should be_true
      checkbox.click
      checkbox.checked?.should be_false
    end

    # TODO work out whether #selected? exists, and whether it replaces
    # #checked?
    it 'can click option elements' do
      browser.url = fixture('forms_with_input_elements.html')

      select = window.find_by_id('new_user_country')
      select.click
      select.option[0].click
      select.option[0].selected?.should be_true
    end
  end

  describe '#mouse_down!' do
    it 'triggers a mousedown event' do
      browser.url = fixture('mouse.html')
      log = window.find_by_id('log').first
      log.mouse_down! 0, 0
      log.text.should include 'down'
      log.mouse_up! 0, 0
    end
  end

  describe '#mouse_up' do
    it 'triggers a mouseup event' do
      browser.url = fixture('mouse.html')
      log = window.find_by_id('log').first
      log.mouse_down! 0, 0
      log.mouse_up! 0, 0
      log.text.should include 'up'
    end
  end

  describe '#mouse_move' do
    it 'triggers a mousemove event' do
      browser.url = fixture('mouse.html')
      log = window.find_by_id('log').first
      log.mouse_move! 0, 0
      log.text.should include 'move'
    end

    it 'moves the mouse' do
      browser.url = fixture('mouse.html')
      log = window.find_by_id('log').first
      h1 = window.find_by_tag('h1').first

      h1.mouse_down! 0, 0
      h1.mouse_move! 25, 25
      h1.mouse_up! 50, 50

      window.eval_js('!!document.getSelection()').should be_true
    end
  end

  # check!
  describe '#check!' do
    before :each do
      browser.url = fixture('forms_with_input_elements.html')
      @checkbox_unchecked = window.find_by_id('new_user_interests_cars').first
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

    it 'cannot uncheck a radio button' do
      @radio_checked.uncheck!.should raise_error
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

    it 'does not appear on a radio button' do
      @radio_checked.should_not respond_to :toggle_check!
    end
  end

  # enable!
  describe '#enable!' do
    it 'enables a form element' do
      window.url = fixture('forms_with_input_elements.html')
      disabled = window.find_by_id('new_user_species').first
      disabled.enabled?.should be_false
      disabled.enable!
      disabled.enabled?.should be_true
    end
  end
  # disable!
  describe '#disable!' do
    it 'disables a form element' do
      window.url = fixture('forms_with_input_elements.html')
      disabled = window.find_by_id('new_user_email').first
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

  describe '#trigger!' do
    it 'fires the given event on the element' do
      window.find_by_id('link_3').first.trigger!('click')
      browser.url.should include 'forms_with_input_elements.html'
    end

    it 'fires event handlers' do
      window.find_by_id('html_test').first.trigger!('dblclick')
      window.find_by_id('messages').first.text.should include 'double clicked'
    end
  end

  # attributes
  # ----------

  # style

end
