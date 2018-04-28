class Module
  def +(trait)
    unModulo = Module.new

    mis_metodos = instance_methods(false)
    sus_metodos = trait.instance_methods(false)

    conflictivos = mis_metodos & sus_metodos
    sus_metodos -= conflictivos
    sus_metodos.concat mis_metodos

    for i in 0...sus_metodos.length
      unModulo.send(:define_method,sus_metodos[i].to_s) do
          if(conflictivos.include? sus_metodos[i])
            raise 'Metodos conflictivos'
          elsif
            trait.method(sus_metodos[i]).call
          end
      end
    end

    unModulo
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
