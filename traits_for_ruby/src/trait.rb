require_relative 'class'

module Algebra
  def +(trait)
    unModulo = Module.new

    mis_metodos = instance_methods(false)
    sus_metodos = trait.instance_methods(false)

    conflictivos = mis_metodos & sus_metodos
    sus_metodos -= conflictivos

    sus_metodos.each do |metodo|
      unModulo.send(:define_method, metodo.to_s) do
        if conflictivos.include? metodo
          #Lanzar excepcion
          proc {|*args| raise 'Metodo conflictivo' }
        elsif mis_metodos.include? metodo
          # send(method(sus_metodos[i]).to_s)
        else
          trait.send method(metodo).to_s
        end
      end
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
  def self.define(name, methods_name, behaviour)
    Object.const_set name, Module.new
    Kernel.const_get(name).singleton_class.include(Algebra)
    i = 0
    methods_name.each do |method|
      Kernel.const_get(name).send(:define_method, method, &behaviour[i])
      i += 1
    end
  end

end

name = :I
Trait.define name, [:w,:r],[proc {puts "hola"},proc {puts "asd"}]

name2 = :J
Trait.define name2, [:p,:r],[proc {puts "chau"},proc {puts "asddd"}]

class A
  uses I - :r
end

a_class = A.new

puts a_class.methods.to_s




