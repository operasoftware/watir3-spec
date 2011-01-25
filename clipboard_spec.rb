# encoding: utf-8
require File.expand_path('../watirspec_helper', __FILE__)

# These tests use the clipboard gem. On Linux, this gem requires
# the xclip package to be installed.
require 'clipboard'


# Clipboard API
# ---------------
describe '#select_all' do
  it 'selects the value of an input field' do
    browser.url = fixture('input_fields_value.html')
    window.find_by_name('one').click!
    browser.select_all
    window.eval_js('window.getSelection()').to_s should == 'foobar'
  end
end

describe '#copy' do
  before :each do
    Clipboard.clear
    browser.url = fixture('input_fields_value.html')
    window.find_by_name('one').click!
    browser.select_all
  end

  it 'copies a string to the keyboard' do
    browser.copy
    Clipboard.paste.should == 'foobar'
  end

  it 'leaves the copied string alone' do
    browser.copy
    window.find_by_name('one').value.should == 'foobar'
  end
end

describe '#cut!' do
  before :each do
    Clipboard.clear
    browser.url = fixture('input_fields_value.html')
    window.find_by_name('one').click!
    browser.select_all
  end

  it 'copies a string to the keyboard' do
    browser.cut!
    Clipboard.paste.should == 'foobar'
  end

  it 'removes the cut string' do
    browser.cut!
    window.find_by_name('one').value.should == ''
  end
end

describe '#paste' do
  before :each do
    Clipboard.clear
    browser.url = fixture('input_fields_value.html')
    window.find_by_name('one').click!
    browser.select_all
  end

  it 'pastes a copied string' do
    browser.copy
    window.find_by_name('two').click!
    browser.paste
    window.find_by_name('two').value.should == 'foobar'
  end

  it 'pastes a cut string' do
    browser.cut
    window.find_by_name('two').click!
    browser.paste
    window.find_by_name('two').value.should == 'foobar'
  end
end
