require 'yaml'
require 'ostruct'
require 'monitor'

class Fig

  # Constructor...
  #
  # ===Params
  # * *file_path* - Path to the config file that should be loaded.
  def initialize(file_path)
    @file_path = file_path
    load
  end

  # Returns the config file file as a YAML Hash.
  attr_reader :yaml


  # Returns an OpenStruct object representation of the config file.
  # This allows you to access config settings with dot notation.
  attr_reader :settings

  # The safest way to get a config setting.
  # Requesting a non-exsisting key, will simply return a nil value instead of raising an error.
  #
  # Examples:
  # Fig.get_setting('some.nested.setting')
  #
  # ===Params
  # * *key* - A case insensivie config key
  #
  # *Returns* The value of the config setting requested.
  #   This may be the value itself or an OpenStruct containing child args
  def get_setting(key)
    setting = settings
    keys = key.to_s.downcase.split(/\./)

    keys.each do |k|
      item = eval("setting.#{k}")
      return nil unless item
      setting = item
    end

    setting
  end

  # Loads the config file and builds the internal Fig objects.
  # Can be used to reload the file when changes have been made.
  def load
    @yaml = YAML.load_file(@file_path)
    @yaml.each {|k, v| interpolate_setting(v)}
    @settings = OpenStruct.new
    add_hash(@settings, @yaml)
  end

private

  # Invoked recursively to implicitly interpolate all settings for the passed value.
  # Config values that contain the pattern /{fig:/ are implicitly interpolated,
  # replacing the "fig" placeholder with the actual value from elsewhere in the config file.  
  #  
  # Example:
  #   name: Nathan Hopkins
  #   message: "This is a test! Hello #{fig:example.name}"
  #
  # ===Params
  # * *value* [_Object_] The value to interpolate.
  def interpolate_setting(value)
    if value.is_a?(Hash)
      value.each {|k,v| interpolate_setting(v) } 
    elsif value.is_a?(String)
      pattern = /\{fig:/i
      start = value.index(pattern, 0)
      replace = {}
      
      while start
        finish = value.index(/\}/, start)
        key = value[(start + 1)..(finish - 1)]
        replace[key] = eval("@yaml['#{key.sub(/^fig:/i, "").gsub(/\./, "']['")}'].to_s")  
        start = value.index(pattern, finish)
      end
      
      value.interpolate(replace, true)
    end
  end
  
  # Recursively adds a hash to an OpenStruct object, ultimately creating a complete OpenStruct object with attributes
  # for all key/value pairs in the Hash.
  # 
  # ===Params
  # * *obj* - The OpenStruct object to add Hash args to.
  # * *hash* - The Hash to pull args from.
  def add_hash(obj, hash)
    return unless hash

    hash.each do |key, value|
      if value.class == Hash
        eval "obj.#{key} = OpenStruct.new"
        add_hash(eval("obj.#{key}"), value)
      else
        eval "obj.#{key.downcase} = value"  
      end
    end
  end
   
end