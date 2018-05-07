module Strategy
  def default_strategy(new_module, name_method, methods)
    new_module.send(:define_method, name_method){
      raise 'Metodo conflictivo'
    }
  end

  def execute_all(new_module, name_method, methods)
    new_module.send(:define_method, name_method) do
      methods.each do |a_method|
        a_method.call
      end
    end
  end

 def foldi(a_function, new_module, name_method, methods)
    new_module.send(:define_method, name_method)do
      method_values = []
      methods.each do |method|
        method_values.push(method.call)
      end
      a_function.call method_values
    end
  end
end
