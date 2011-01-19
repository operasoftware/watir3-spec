# encoding: utf-8
require File.expand_path('../watirspec_helper', __FILE__)

# keyboard input
# ---------------
describe '#keys' do

  describe '#send' do
    before :each do
      browser.url = fixture('two_input_fields.html')
      window.find_by_name('one').click!
    end

    it 'types a single character' do
      browser.keys.send 'A'
      window.find_by_name('one').text.should == 'A'
    end

    it 'types a mixed-case string' do
      browser.keys.send 'ABC abc'
      window.find_by_name('one').text.should == 'ABC abc'
    end

    it 'types a string containing multi-byte characters' do
      browser.keys.send 'ルビー 水'
      window.find_by_name('one').text.should == 'ルビー 水'
    end

    it 'types many single characters in sequence' do
      browser.keys.send 'A', 'B', 'C', 'D', 'E', 'F',  'G',  'H',  'I',  'J',  'K',  'L',  'M',  'N',  'O',  'P',  'Q',  'R',  'S',  'T',  'U', 'V',  'W',  'X',  'Y',  'Z'
      window.find_by_name('one').text.should == 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    end

    it 'moves the caret using arrow keys' do
      browser.keys.send 'AC', :left, 'B'
      window.find_by_name('one').text.should == 'ABC'
    end

    it 'switches to a different input element with tab' do
      browser.keys.send 'AB', :tab, 'C'
      window.find_by_name('one').text.should == 'AB'
      window.find_by_name('two').text.should == 'C'
    end

    it 'uses modifier keys' do
      browser.keys.send [:shift, 'a'], 'bc'
      window.find_by_name('one').text.should == 'Abc'
    end

    it 'uses multiple modifier keys to manipulate selection' do
      browser.keys.send 'ABC 123'
      browser.keys.send [:shift, :control, :left], :backspace
      window.find_by_name('one').text.should == 'ABC '
    end

    # TODO: This should return an exception.
    # it 'presses an invalid key' do
    #   browser.keys.send :hoobaflooba
    # end
  end

  describe '#down' do
    it 'types a mixed-case string by holding shift' do
      browser.url = fixture('two_input_fields.html')
      window.find_by_name('one').click!
      browser.keys.send 'a'
      browser.keys.down :shift
      browser.keys.send 'b'
      window.find_by_name('one').text.should == 'aB'
      browser.keys.up :shift
    end

    it 'holds down a non-modifier key for one second' do
      browser.url = fixture('two_input_fields.html')
      window.find_by_name('one').click!
      browser.keys.down 'a'
      sleep 1
      browser.keys.up 'a'
      window.find_by_name('one').text.should include 'aa' # Two or more characters are expected.
    end

    it 'triggers onkeydown' do
      browser.url = fixture('keys.html')
      browser.keys.down :shift
      window.find_by_id('log').text.should include 'down, 16'
      browser.keys.up :shift
    end

    it 'does not trigger onkeyup' do
      browser.url = fixture('keys.html')
      browser.keys.down :shift
      window.find_by_id('log').text.should_not include 'up, 16'
      browser.keys.up :shift
    end

    it 'presses two buttons at the same time' do
      browser.url = fixture('keys.html')
      browser.keys.down :shift, :control
      window.find_by_id('log').text.should include 'down, 16'
      window.find_by_id('log').text.should include 'down, 17'
      browser.keys.up :shift
      browser.keys.up :control
    end

    # TODO: This should return an exception.
    # it 'presses an invalid key' do
    #   browser.keys.down :hoobaflooba
    # end

    # TODO: This should return an exception.
    # it 'passes an array instead of a string' do
    #   browser.keys.down [:shift, :control]
    # end
  end

  describe '#up' do
    it 'types a mixed-case string by holding shift' do
      browser.url = fixture('two_input_fields.html')
      window.find_by_name('one').click!
      browser.keys.down :shift
      browser.keys.send 'a'
      browser.keys.send 'b' # Testing that we do not release prematurely
      browser.keys.up :shift
      browser.keys.send 'c'
      window.find_by_name('one').text.should == 'ABc'
    end

    it 'holds down a non-modifier key for one second (but no longer)' do
      browser.url = fixture('two_input_fields.html')
      window.find_by_name('one').click!
      browser.keys.down 'a'
      sleep 1
      browser.keys.up 'a'
      result_string = window.find_by_name('one')
      sleep 1
      window.find_by_name('one').text.should == result_string
      result_string = nil
    end

    it 'triggers onkeyup' do
      browser.url = fixture('keys.html')
      browser.keys.down :shift
      browser.keys.up :shift
      window.find_by_id('log').text.should include 'up, 16'
    end

    it 'presses two buttons, but releases only one' do
      browser.url = fixture('keys.html')
      browser.keys.down :shift, :control
      browser.keys.up :shift
      window.find_by_id('log').text.should include 'up, 16'
      window.find_by_id('log').text.should_not include 'up, 17'
      browser.keys.up :control
    end

    it 'releases two buttons' do
      browser.url = fixture('keys.html')
      browser.keys.down :shift, :control
      browser.keys.up :shift, :control
      window.find_by_id('log').text.should include 'up, 16'
      window.find_by_id('log').text.should include 'up, 17'
    end

    # TODO: This should return an exception.
    # it 'presses an invalid key' do
    #   browser.keys.down :hoobaflooba
    # end

    # TODO: This should return an exception.
    # it 'passes an array instead of a string' do
    #   browser.keys.up [:shift, :control]
    # end

  end

  describe '#release' do
    before :each do
      browser.url = fixture('keys.html')
      window.find_by_name('one').click!
    end

    it 'releases one button' do
      browser.keys.down :shift
      browser.keys.send 'a'
      browser.keys.release
      browser.keys.send 'b'
      window.find_by_name('one').text.should == 'Ab'
    end

    it 'releases two buttons' do
      browser.keys.down :shift, :control
      browser.keys.release
      window.find_by_id('log').text.should include 'up, 16'
      window.find_by_id('log').text.should include 'up, 17'
    end
  end
end
