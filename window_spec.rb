# encoding: utf-8
require File.expand_path('../watirspec_helper', __FILE__)

describe 'Window' do

  before :each do
    browser.url = fixture('non_control_elements.html')
  end

  # element access
  # --------------

  describe '#find_elements_by_id' do
    it 'returns an element with the given ID' do
      elements = window.find_elements_by_id('header')

      elements.should_not be_empty
      elements.length.should == 1
      elements.first.attr(:id).should == 'header'
    end
  end

  describe '#find_elements_by_tag' do
    it 'is not empty if the tag exists' do
      window.find_elements_by_tag(:div).should_not be_empty
    end

    it 'contains all elements of the tag name' do
      window.find_elements_by_tag(:div).all? do |element|
        element.tag_name == 'div'
      end.should be_true
    end

    it 'contains only elements restricted by the selector' do
      window.find_elements_by_tag(:div, :title => 'Lorem ipsum').all? do |element|
        element.attr(:title) == 'Lorem ipsum'
      end.should be_true
    end

    it 'empty if the elements do not exist' do
      window.find_elements_by_tag(:hoobaflooba).should be_empty
    end
  end

  # css
  # we don't want a complete CSS selector test suite here, so just some common
  # selectors
  describe '#find_elements_by_css' do
    it 'is not empty if an element matches the css selector' do
      window.find_elements_by_css('#outer_container > div').should_not be_empty
    end

    it 'contains all elements selected by the selector' do
      window.find_elements_by_css('#outer_container > div').all? do |element|
        element.parent.attr(:id).should == 'outer_container'
      end.should be_true
    end

    it 'empty if the selector does not match' do
      window.find_elements_by_css('#hoobaflooba').should be_empty
    end
  end

  # class
  describe '#find_elements_by_class' do
    it 'is not empty if an element matches the class' do
      window.find_elements_by_class(:lead).should_not be_empty
    end

    it 'contains all elements with the given class' do
      window.find_elements_by_class(:lead).all? do |element|
        element.attr(:class).should match /lead/
      end.should be_true
    end

    it 'finds elements with multiple classes' do
      window.find_elements_by_class(:one).all? do |element|
        element.attr(:class).should match /one/
      end.should be_true
    end

    it 'is empty if the class does not match' do
      window.find_elements_by_class(:hoobaflooba).should be_empty
    end
  end

  # xpath
  describe '#find_elements_by_xpath' do
    before :all do
      @headers = window.find_elements_by_xpath('//h1')
    end

    it 'is not empty if elements matches the class' do
      @headers.should_not be_empty
    end

    it 'contains all elements with the given query' do
      @headers.all? do |element|
        element.tag.should == 'H1'
      end
    end

    it 'is empty if the query does not match' do
      window.find_elements_by_xpath('//hoobaflooba').should be_empty
    end
  end

  # properties
  # ----------

  describe '#title' do
    it 'is the title of the window' do
      window.title.should == 'Non-control elements'
    end

    it 'changes when the title tag changes' do
      window.find_elements_by_tag(:title).first.text = 'changed'
      window.title.should == 'changed'
    end
  end

  describe '#source' do
    it 'is the source of the page' do
      window.source.should match /^    <title>Non-control elements<\/title>/
    end

    it 'is the original source' do
      window.find_elements_by_tag(:title).first.text = 'changed'
      window.source.should match /^    <title>Non-control elements<\/title>/
    end
  end

  # page management
  # ---------------

  describe '#url' do
    it 'is the url of this window' do
      window.url.should == fixture('non_control_elements.html')
    end
  end

  describe '#url=' do
    it 'navigates to the given url' do
      window.url = fixture('forms_with_input_elements.html')
      window.find_elements_by_tag(:title).first.text.should == 'Forms with input elements'
    end
  end

  describe '#back' do
    it 'goes back one page in history' do
      window.url = fixture('forms_with_input_elements.html')
      window.back
      window.url.should == fixture('non_control_elements.html')
    end

    # should it raise an exception if it fails instead?
    it 'is true if it is possible to go back' do
      window.url = fixture('forms_with_input_elements.html')
      window.back.should be_true
    end

    it 'is false if there is no page to go back to' do
      window.back.should be_false
    end
  end

  describe '#forward' do
    it 'goes forward one page in history' do
      window.url = fixture('forms_with_input_elements.html')
      window.back
      window.forward
      window.url.should == fixture('forms_with_input_elements.html')
    end

    # should it raise an exception if it fails instead?
    it 'is true if it is possible to go forward' do
      window.url = fixture('forms_with_input_elements.html')
      window.back
      window.forward.should be_true
    end

    it 'is false if there is no page to go forward to' do
      window.forward.should be_false
    end

  end

  describe '#refresh' do
    it 'refreshes the current page' do
      title = window.find_elements_by_tag(:title).first
      title.text = 'changed'
      title.text.should == 'changed'

      window.refresh
      title.text.should == 'Non-control elements'
    end
  end

  # actions
  # -------

  # click(x,y)

  describe '#eval_js' do
    it 'executes Javascript in the page' do
      window.eval_js('document.title = "test"')
      window.title.should == 'test'
    end

    it 'returns an element when the Javascript does' do
      window.eval_js('document.createElement("div")').tag_name.should =~ /div/i
    end

    it 'returns a number when the Javascript does' do
      window.eval_js('Math.abs(-5)').should == 5
    end

    it 'returns a boolean when the Javascript does' do
      window.eval_js('(function(){return true;})()').should be_true
    end

    it 'returns an array when the Javascript does' do
      result = window.eval_js('["this", "is", "a", "test"]')  # WTR-227
      result.length.should == 4
      result[3].should == 'test'
    end

    it 'returns a string when the result is not one of these types' do
      window.eval_js('({one:"two"}).toString()').should == '[object Object]'
    end
  end

  # window management
  # -----------------

  describe '#maximize' do
    before :each do
      # Make sure we aren't already maximized
      window.restore
    end

    it 'maximizes the window' do
      body = window.find_elements_by_tag(:body).first
      width = body.width
      window.maximize
      body.width.should be > width
    end
  end

  describe '#restore' do
    it 'restores (unmaximizes) the window' do
      body = window.find_elements_by_tag(:body).first
      # Make sure we aren't already restored
      window.maximize
      width = body.width
      window.restore
      body.width.should be < width
    end
  end

  describe '#exists?' do
    it 'is true if the window exists' do
      window.exists?.should be_true
    end

    it 'is false if the window does not exist' do
      window.close
      window.exists?.should be_false
    end
  end

  describe '#close' do
    it 'destroys the window' do
      window.close
      window.exists?.should be_false
      window.find_elements_by_tag(:title).should raise_error
    end
  end

  describe '#new' do
    it 'creates a new window' do
      new_window = browser.url(fixture('non-control-elements.html'))
      new_window.exists?.should be_true
      new_window.url.should == fixture('non-control-elements.html')
    end
  end
end
