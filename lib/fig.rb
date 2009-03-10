require 'yaml'
require 'ostruct'
require 'monitor'
 
class << String
  
  # Allows various forms of string interpolation.
  # Initially intended to make it easier to dynamically replace YAML config values;
  # howerver, this will likely come in handy elsewhere.
  # 
  # Examples:
  #   "Hello! My name is ?".interpolate("Nathan Hopkins")
  #   "Hello! My first name is ? and my last name is ?".interpolate(["Nathan", "Hopkins"])
  #   'Hello! My first name is #{first_name} and my last name is #{last_name}'.interpolate(:first_name => "Nathan", :last_name => "Hopkins")
  # 
  # ===Params
  # * *args* [Object, Array, Hash] The value(s) used to replace segments of the string.
  # * *in_place* [Boolean] Indicates if the value should edited in place.  
  #   Be careful when doing this, you may end up with unexpected results!
  #   
  # ===Returns
  # The new string after interpolation.
  def interpolate(args, in_place=false)
    args = [args] unless args.is_a?(Array) || args.is_a?(Hash)
    
    if args.is_a?(Array)
      x = -1
      
      if in_place
        self.gsub!(/\?/) do |s|
          x += 1
          args[x]
        end
      else
        return self.gsub(/\?/) do |s|
          x += 1
          args[x]
        end
      end
    elsif args.is_a?(Hash)
      if in_place
        args.each {|k, v| self.gsub!(/#\{#{k.to_s}\}/i, v)}
      else
        new_string = self
        args.each {|k, v| new_string = new_string.gsub(/#\{#{k.to_s}\}/i, v.to_s)}
        return new_string
      end
    end
    
    return self
  end
  
end

class Fig
  @@file_path = "#{RAILS_ROOT}/config/fig.yml"
  @@lock = Monitor.new 
  @@yaml = YAML.load_file(@@file_path)
  @@yaml_interpolated = false
  @@settings = nil

  # Returns the fig.yml file as a Hash
  def self.yaml
    @@lock.synchronize do
      unless @@yaml_interpolated
        # loop until all replacements are complete
        while @@yaml.to_s =~ /#\{config:/i
          @@yaml.each {|key, value| interpolate_setting(value) }
        end
        @@yaml_interpolated = true
      end
    end
    
    return @@yaml
  end

  # Returns an OpenStruct object representation of the fig.yml file.
  # This allows you to access config settings with dot notation.
  # If you ask for a property that doesn't exist, you get nil rather than an error
  # because this is an OpenStruct.
  def self.settings
    obj = nil
    
    @@lock.synchronize do
      unless @@settings
        @@settings = OpenStruct.new
        add_hash(@@settings, Fig.yaml)
      end
      
      obj = @@settings
    end

    return obj
  end

  # The safest way to get a config setting.
  # If you request a non-exsisting key in the middle of your string,
  # you will get a nil value rather than an Error.
  #
  # Examples:
  # Fig.get_setting('US.attus.sms_email')
  #
  # ===Params
  # * key [String] A case insensivie string representation of the config setting
  #
  # *Returns* The value of the config setting requested.
  #   This may be the value itself or an OpenStruct containing child args
  def self.get_setting(key)
    setting = self.settings
    keys = key.to_s.downcase.split(/\./)

    keys.each do |k|
      
      item = eval("setting.#{k}")
      return nil unless item
      setting = item
    end

    return setting
  end
  
  # Changes a setting's value in memory only.
  # The change isn't persisted to the fig.yml file.
  # TODO: persist the change to the fig.yml file.
  def self.change_setting(key, value)    
    keys = key.split(".")
    hash = self.yaml
    
    keys.each do |k| 
      if k == keys[-1]
        hash[k] = value
        break
      end

      hash = hash[k] 
    end

    @@lock.synchronize do
      @@settings = nil
    end
  end

  # Forces a reload of the fig.yml file
  # and rebuilds the Fig internal objects.
  def self.reload
    puts "Inside of Fig.reload"
    @@lock.synchronize do
      puts "Reloading #{@@file_path}"
      @@yaml = YAML.load_file(@@file_path)
      @@yaml_interpolated = false
      @@settings = nil
    end
  end

private

  # Used to implicitly interpolate config settings in the fig.yml file.
  # Any String config values that contain the pattern /#{config:/ are implicitly interpolated, 
  # replacing the "config" placeholder with the actual value from elsewhere in the config file.  
  # 
  # The following YAML config example will implicitly replace
  # #{config:interpolation_example.name} with "Nathan Hopkins":
  #  
  #  interpolation_example:
  #    name: Nathan Hopkins
  #    message: "This is a test! Hello #{config:interpolation_example.name}"
  #
  # NOTE: This functionality is intended to simplify dynamic configs.
  # NOTE: You can include as many replacements in a setting as you like.
  #
  # ===Params
  # * *value* [_Object_] The value to interpolate.
  def self.interpolate_setting(value)
    if value.is_a?(Hash)
      value.each {|k,v| interpolate_setting(v) } 
    elsif value.is_a?(String)
      pattern = /\#\{config:/i
      start = value.index(pattern, 0)
      replace = {}
      
      while start
        finish = value.index(/\}/, start)
        key = value[(start + 2)..(finish - 1)]
        replace[key] = eval("@@yaml['#{key.sub(/^config:/i, "").gsub(/\./, "']['")}'].to_s")
        start = value.index(pattern, finish)
      end
     
      value.interpolate(replace, true)
    end
  end
  
  # Adds a hash to an OpenStruct object.
  # Works recursively, so if one of the Hash args is itself
  # a Hash an new OpenStruct will be created and this method
  # will be invoked again etc... Ultimately creating a complete
  # OpenStruct object with attributes for all key/value pairs in the Hash.
  # 
  # ===Params
  # * obj [OpenStruct] The object to add Hash args to.
  # * hash [Hash] The has to pull args from.
  def self.add_hash(obj, hash)
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

# Shortcut to Fig.get_setting
def fig(key)
  Fig.get_setting(key)
end