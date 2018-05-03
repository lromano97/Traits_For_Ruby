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

name = :I
Trait.define name, {:w => proc {puts "hola"}, :r => proc {puts "asd"}}

name2 = :J
Trait.define name2, {:p => proc {puts "chau"}, :r=>proc {puts "asddd"}}

class A
  uses I << (:r > :hola)
end

a_class = A.new

puts a_class.methods.to_s

puts a_class.hola
