require 'active_support/core_ext/object/blank'
module Replaceable
  def self.include_me!(_class)
    _class.class_eval do
      include Replaceable
    end
  end

  def replace_values!(locals)
    locals.each{ |key, val| self.gsub!("%%#{key.to_s.upcase}%%", val) }
    self
  end

  def parse_and_replace_values!(locals, proc_param=nil)
    self.replace_values!(self.parse_variables(locals, proc_param))
  end

  def parse_variables(locals, proc_param=nil)
    locals.reject!{ |key, val| !required_variable?(key) }
    locals.select{ |key, val| val.is_a?(Proc) }.
           each{ |key, proc| locals[key] = call_proc(proc, proc_param) }
    locals
  end

  private
  def call_proc(proc, param)
    # when a param is required it should not be nil otherwise return an empty string
    proc.parameters.empty? ? proc.call : call_proc_with_param(proc, param)
  end

  def call_proc_with_param(proc, param)
    (!param.nil? ? proc.call(param) : "")
  end

  def required_variable?(var)
    !self[%r{\%\%#{var.to_s.upcase}\%\%}].blank?
  end
end

Replaceable.include_me!(String)