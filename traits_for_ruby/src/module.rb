class Module
  def +(trait)
    unModulo = Module.new

    mis_metodos = instance_methods(false)
    sus_metodos = trait.instance_methods(false)

    conflictivos = mis_metodos & sus_metodos
    sus_metodos -= conflictivos
    sus_metodos.concat mis_metodos



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

    for i in 0...my_methods.length
      a_module.send(:define_method, my_methods[i])do
        self.method(my_methods[i])
      end
    end
    a_module
  end
end