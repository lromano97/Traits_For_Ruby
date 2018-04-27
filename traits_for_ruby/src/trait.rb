class Class
  def uses(a_module)
    include(a_module)
  end
end

class Module
  def +(a_module)
    my_methods = instance_methods(false)
    its_methods = a_module.instance_methods(false)

    conflict_methods = my_methods & its_methods

    newModule = Module.new

    for i in 0...its_methods.length
      newModule.send(:define_method, its_methods[i]) do
        a_module.method(its_methods[i]).call
      end
    end
    #Redefinir los metodos con Raise error
  end
end

class Trait
  def self.define(name, methods_name, behaviour)
    Object.const_set name, Module.new
    for i in 0...methods_name.length
      Kernel.const_get(name).send(:define_method, methods_name[i],
                                  &behaviour[i])
    end
  end
end




