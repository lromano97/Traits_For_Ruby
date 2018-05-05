require_relative 'class'
require_relative 'algebra'
require_relative 'symbol'


class Trait
  def self.define(name, method_map_hash)
    Object.const_set name, Module.new
    Kernel.const_get(name).singleton_class.include(Algebra)
    methods_key = method_map_hash.keys
    methods_key.each do |method|
      Kernel.const_get(name).send(:define_method, method, method_map_hash[method])
    end
  end
end
