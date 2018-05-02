require_relative 'class'
require_relative 'module'



class Trait
  def self.define(name, methods_name, behaviour)
    Object.const_set name, Module.new
    for i in 0...methods_name.length
      Kernel.const_get(name).send(:define_method,methods_name[i],&behaviour[i])
    end
  end
end

name = :I
Trait.define name, [:w,:r],[proc {puts "hola"},proc {puts "asd"}]

name2 = :J
Trait.define name2, [:p,:r],[proc {puts "chau"},proc {puts "asddd"}]


class A
  uses I+J
end

a_class = A.new()
puts a_class.methods.to_s

a_class.p


