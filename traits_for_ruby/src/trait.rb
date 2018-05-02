require_relative 'class'

module Algebra
 def default_strategy(new_module, trait, mis_metodos, sus_metodos)
    conflictivos = mis_metodos & sus_metodos
    sus_metodos -= conflictivos
    mis_metodos -= conflictivos

    new_module_methods = conflictivos + sus_metodos + mis_metodos

    hash = {}

    new_module_methods.each do |metodo|
      if conflictivos.include? metodo
        hash[metodo] = proc {|*args| raise 'Metodo conflictivo' }
      elsif mis_metodos.include? metodo
        hash[metodo] = instance_method(metodo)
      else
        hash[metodo] = trait.instance_method(metodo)
      end
    end

    hash

  end

  def +(trait)
    unModulo = Module.new

    mis_metodos = instance_methods(false)
    sus_metodos = trait.instance_methods(false)

    hash = default_strategy unModulo, trait, mis_metodos, sus_metodos

    nombres_metodos=hash.keys
    nombres_metodos.each do |metodo|
      unModulo.send(:define_method,metodo,hash[metodo])
    end

    unModulo
  end

  def -(a_method)
    a_module = Module.new

    my_methods = instance_methods(false)
    the_method = []
    the_method << a_method

    my_methods -= the_method

    my_methods.each do |method|
      a_module.send(:define_method, method, self.instance_method(method))
    end
    a_module
  end
end

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
  uses I + J
end

a_class = A.new

puts a_class.methods.to_s

a_class.p


