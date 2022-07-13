module Validation
  def self.included(kras)
    kras.extend(ClassMethods)
  end

  module ClassMethods
    @@rule_types = [:presence, :format, :type]
    @@error_messages = {
      presence: "Not be neither nil nor an empty string",
      format: "Mismatch the passed regular expression",
      type: "Not an instance of the passed class"
    }

    # @return
    # a rule container`s name for each class
    def r_name
      "@@#{self.to_s.downcase}rules"
    end

    # @return
    # list of the validation rules for current class
    def rules
      eval("#{r_name}rules ||= {}" )
    end

    def error_messages; @@error_messages end

    # @action
    # add new rule in validation list
    def validate name, rule
      if @@rule_types.include?( rule.keys.first )
        rules[name] = rule
      else
        raise "Validation Error: unsupported validation rule key => \"#{rule.keys.first}\" <=. "
      end
    end
  end


  def valid?
    self.class.rules.each do |key, value|
      return false unless validate_attribute key, value
    end
    true
  end

  def validate!
    self.class.rules.each do |key, value|
      validate_attribute key, value, true
    end
    true
  end

  private

  def presence? name, rule
    point = self.send(name)
    !point.nil? && !(point.is_a?(String) && point.empty?)
  end

  def format? name, format
    point = self.send(name)
    point =~ format
  end

  def type? name, type
    point = self.send(name)
    point.is_a? type
  end

  def raise_error key, rule_name, rule_value
    raise render_error_message(key, rule_name, rule_value)
  end

  def render_error_message key, rule_name, rule_value
    message_start = "Validation Failed for \"#{key}\":"
    value         = "==>\"#{send(key)}\"<=="
    error_text    = "#{self.class.error_messages[rule_name]}"
    body          = "#{value} #{error_text}"
    message_end   = rule_value == true ? "" :  rule_value

    "#{message_start} #{body} #{message_end}."
  end

  def validate_attribute key, rules, noise = false
    rules.each_pair do |rule_name, rule_value|
      valid = send("#{rule_name}?", key, rule_value)
      raise_error(key, rule_name, rule_value) if noise && !valid
      return false unless valid
    end
    true
  end
end
