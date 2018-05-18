module Strategy

  def resolve_with_default(a_module)
    new_module = Module.new
    my_module_methods = a_module.instance_methods(false)
    if(my_module_methods!=[])
      my_module_methods.each do |method_name|
        my_module_method_block = a_module.instance_method(method_name)
        new_module.send :define_method, method_name,  my_module_method_block
      end
    end
    a_module.const_get(:Methods).each do |method_name, block|
      if my_module_methods.include? method_name
        my_module_method_block = a_module.instance_method(method_name)
        DefaultStrategy.new.resolve(new_module, method_name, block+my_module_method_block)
      elsif block.is_a? Array
        DefaultStrategy.new.resolve(new_module, method_name, block)
      else
        new_module.send :define_method, method_name, block
      end
    end
    new_module
  end

  def apply_each_strategy(hash_map, a_module)
    new_module = Module.new
    my_module_methods = a_module.instance_methods(false)
    if(my_module_methods!=[])
      my_module_methods.each do |method_name|
        my_module_method_block = a_module.instance_method(method_name)
        new_module.send :define_method, method_name,  my_module_method_block
      end
    end
    hash_map.each do |strategy_name, value|
      a_module.const_get(:Methods).each do |method_name, block|
        if value.include? method_name
          if strategy_name === :DefaultStrategy || strategy_name === :ExecuteAllStrategy
            Strategy.const_get(strategy_name).new.resolve new_module, method_name, block
          else
            a_strategy = Strategy.const_get(strategy_name).new
            a_strategy.resolve new_module, method_name, block, value.last
          end
        elsif block.is_a? Array
          DefaultStrategy.new.resolve(new_module, method_name, block)
        else
          new_module.send :define_method, method_name, block
        end
      end
    end
    new_module
  end

  class DefaultStrategy
    def resolve(new_module, name_method, _methods)
      new_module.send(:define_method, name_method)do
        raise 'Metodo conflictivo'
      end
    end
  end

  class ExecuteAllStrategy
    def resolve(new_module, name_method, methods)
      new_module.send(:define_method, name_method)do
        methods.each do |a_method|
          if(a_method.is_a? Proc)
            a_method.call
          else
            a_method.bind(self).call
          end
        end
      end
    end
  end

  class FoldStrategy
    def resolve(new_module, name_method, methods,function_to_apply)
      new_module.send(:define_method, name_method)do
        methods_value = []
        methods.each do |method|
          if(method.is_a? Proc)
            methods_value.push(method.call)
          else
            methods_value.push(method.bind(self).call)
          end
        end
        function_to_apply.call methods_value
      end
    end
  end

  class ConditionalStrategy
    def resolve(new_module, name_method, methods,function_to_apply)
      new_module.send(:define_method, name_method)do
        methods.each do |a_method|
          if a_method.is_a? Proc && (function_to_apply.call a_method.call)
            a_method.call
            break
          elsif function_to_apply.call a_method.bind(self).call
            a_method.bind(self).call
            break
          end
        end
      end
    end
  end
end

class RandomStrategy
  def resolve(new_module, name_method, methods,function_to_apply)
    new_module.send(:define_method, name_method)do
      function_to_apply.call methods
    end
  end
end