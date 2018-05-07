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
      a_value = methods[0].call
      methods.delete(0)
      methods.each do |method|
        a_value = method.call a_value
      end
      a_value
    end
  end
end