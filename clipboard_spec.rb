require File.expand_path('../watirspec_helper', __FILE__)

# These tests use the clipboard gem.  On GNU/Linux, this gem requires
# the xclip package to be installed.  On Windows and Mac, it should
# work out of the box.
require 'clipboard'

describe 'Browser' do

  before :each do
    Clipboard.clear
    browser.url = fixture('input_fields_value.html')
    window.find_by_id('one').click
    browser.select_all
  end

  describe '#select_all' do
    it 'selects the value of an input field' do
      window.execute_script('one = document.getElementById("one");')
      window.execute_script('one.value.substr(one.selectionStart, one.selectionEnd - one.selectionStart)').to_s.should == 'foobar'
    end
  end

  describe '#copy' do
    it 'copies a string to the keyboard' do
      browser.copy
      Clipboard.paste.should == 'foobar'
    end

    it 'leaves the copied string alone' do
      browser.copy
      window.find_by_id('one').value.should == 'foobar'
    end
  end

  describe '#cut' do
    it 'copies a string to the keyboard' do
      browser.cut
      Clipboard.paste.should == 'foobar'
    end

    it 'removes the cut string' do
      browser.cut
      window.find_by_id('one').value.should == ''
    end
  end

  describe '#paste' do
    it 'pastes a copied string' do
      browser.copy
      window.find_by_id('two').click
      browser.paste
      window.find_by_id('two').value.should == 'foobar'
    end

    it 'pastes a cut string' do
      browser.cut
      window.find_by_id('two').click
      browser.paste
      window.find_by_id('two').value.should == 'foobar'
    end
  end

end
