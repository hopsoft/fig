require 'test/unit'
require 'fileutils'
require File.dirname(__FILE__) + '/../lib/hopsoft/fig'

class FigTest < Test::Unit::TestCase
  @@fig = Hopsoft::Fig.new(File.dirname(__FILE__) + '/test.yml')
  
  def test_yaml_values
    assert @@fig.yaml
    assert @@fig.yaml['name'] == 'Nathan Hopkins'
    assert @@fig.yaml['message'] == 'Hello there Nathan Hopkins'
    assert @@fig.yaml['name2'] == 'Page Hopkins'
    assert @@fig.yaml['message2'] == 'Hello there Page Hopkins'
    assert @@fig.yaml['list'].is_a?(Array)
    assert @@fig.yaml['list'].length == 6
    assert @@fig.yaml['parent']['name'] == 'Nathan Hopkins'
    assert @@fig.yaml['parent']['child']['name'] == 'Emma Hopkins'

    assert_raise NoMethodError do
     @@fig.yaml['some']['complete']['garbage']
    end
  end

  def test_settings_values
    assert @@fig.settings
    assert @@fig.settings.name == 'Nathan Hopkins'
    assert @@fig.settings.message == 'Hello there Nathan Hopkins'
    assert @@fig.settings.name2 == 'Page Hopkins'
    assert @@fig.settings.message2 == 'Hello there Page Hopkins'
    assert @@fig.settings.list.is_a?(Array)
    assert @@fig.settings.list.length == 6
    assert @@fig.settings.parent.name == 'Nathan Hopkins'
    assert @@fig.settings.parent.child.name == 'Emma Hopkins'

    assert_raise NoMethodError do
     @@fig.settings.some.complete.garbage
    end
  end

  def test_get_setting
    assert @@fig.get_setting('name') == 'Nathan Hopkins'
    assert @@fig.get_setting('message') == 'Hello there Nathan Hopkins'
    assert @@fig.get_setting('name2') == 'Page Hopkins'
    assert @@fig.get_setting('message2') == 'Hello there Page Hopkins'
    assert @@fig.get_setting('list').is_a?(Array)
    assert @@fig.get_setting('list').length == 6
    assert @@fig.get_setting('parent').name == 'Nathan Hopkins'
    assert @@fig.get_setting('parent').child.name == 'Emma Hopkins'
    assert @@fig.get_setting('some.complete.garbage') == nil
  end

  def test_change_and_reload
    dir_name = File.dirname(__FILE__)
    orig_file = dir_name + '/test.yml'
    new_file = dir_name + '/test2.yml'
    bak_file = dir_name + '/test.yml.bak'

    # make a backup
    FileUtils.rm(bak_file) if File.exist?(bak_file)
    FileUtils.cp orig_file, bak_file

    # swap files
    FileUtils.mv new_file, orig_file, :force => true

    # verify that the file swap didn't change anything implicitly
    test_get_setting 

    # reload
    @@fig.load
    
    # test new settings
    assert @@fig.get_setting('name') == 'Jeff Hopkins'
    assert @@fig.get_setting('message') == 'Hello there Jeff Hopkins'
    assert @@fig.get_setting('name2') == 'Marie Hopkins'
    assert @@fig.get_setting('message2') == 'Hello there Marie Hopkins'
    assert @@fig.get_setting('list').is_a?(Array)
    assert @@fig.get_setting('list').length == 6
    assert @@fig.get_setting('parent').name == 'Jeff Hopkins'
    assert @@fig.get_setting('parent').child.name == 'Nathan Hopkins'
    assert @@fig.get_setting('some.complete.garbage') == nil

    # switch back
    FileUtils.mv orig_file, new_file, :force => true
    FileUtils.mv bak_file, orig_file, :force => true
    @@fig.load
  end


end
