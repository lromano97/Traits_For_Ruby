class Module
  def +(trait)
    unModulo = Module.new

    mis_metodos = instance_methods(false)
    sus_metodos = trait.instance_methods(false)

    conflictivos = mis_metodos & sus_metodos
    sus_metodos -= conflictivos
    sus_metodos.concat mis_metodos

    for i in 0...sus_metodos.length
      unModulo.send(:define_method, sus_metodos[i]) do
          if(conflictivos.include? sus_metodos[i])
            raise 'Metodos conflictivos'
          elsif(mis_metodos.include? sus_metodos[i])
            #self.method(sus_metodos[i]).call
          else
            #trait.method(sus_metodos[i]).call
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

    for i in 0...my_methods.length
      a_module.send(:define_method, my_methods[i])do
        self.method(my_methods[i])
      end
    end
    a_module
  end
end

class Class

  def uses(_unModulo)
    include(_unModulo)
  end

end

class Trait
  def self.define(name, methods_name, behaviour)
    Object.const_set name, Module.new
    if(methods_name!=nil)
    for i in 0...methods_name.length
      Kernel.const_get(name).send(:define_method,methods_name[i],&behaviour[i])
    end
    end
  end
end

name = :I
Trait.define name, [:w,:r],[proc {puts "xdd"},proc {puts "ivan schedule"}]

name2 = :J
Trait.define name2, [:p,:r],[proc {puts "xdd"},proc {puts "ivan schedule"}]


class XD uses I + J
end

hiban = XD.new()
puts hiban.r
