class String

  # Allows various forms of string interpolation.
  # Originally designed to reuse YAML config values; howerver,
  # this will likely come in handy elsewhere.
  # 
  # 
  #   "Hello! My name is ?".interpolate("Nathan Hopkins")
  #   "Hello! My first name is ? and my last name is ?".interpolate(["Nathan", "Hopkins"])
  #   'Hello! My first name is {first_name} and my last name is {last_name}'.interpolate(:first_name => "Nathan",
  #     :last_name => "Hopkins")
  # 
  #
  # ====Params
  # * +args+ - The value(s) used to replace segments of the string.
  # * +in_place+ - Indicates if the value should edited in place.  Be careful when doing this, you may end up with unexpected results!
  # 
  #
  # Returns the new string after interpolation.
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
        args.each {|k, v| self.gsub!(/\{#{k.to_s}\}/i, v.to_s)}
      else
        new_string = String.new(self)
        args.each {|k, v| new_string.gsub!(/\{#{k.to_s}\}/i, v.to_s)}
        return new_string
      end
    end

    return self
  end
end
