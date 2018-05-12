require_relative 'class'
require_relative 'algebra'
require_relative 'strategy'
require_relative 'symbol'

class Trait
  def self.define(name, methods)
    Object.const_set name, Module.new
    Kernel.const_get(name).singleton_class.include(Algebra)
    Kernel.const_get(name).const_set :Methods, Hash.new
    methods.each do |method_name, block|
      Kernel.const_get(name).const_get(:Methods)[method_name] = block
    end
  end
end
