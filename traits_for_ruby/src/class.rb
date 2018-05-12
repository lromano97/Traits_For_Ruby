require_relative 'strategy'

class Class
  def strategy(strategy_hash)
    const_set :Strategy, strategy_hash
  end

  def uses(a_module)
    include Strategy
    un_modulo = Module.new
    if const_get(:Strategy) == Strategy
      method = instance_method(:default_strategy)
      a_module.const_get(:Methods).each do |method_name, block|
        if block.is_a? Array
          method.bind(self).call un_modulo, method_name, block
        else
          un_modulo.send :define_method, method_name, block
        end
      end
    else
      const_get(:Strategy).each do |key,value|
        a_module.const_get(:Methods).each do |method_name, block|
        if value.include? method_name
          if key[0].is_a? Proc
            key[0].call un_modulo, method_name, block
          elsif key.is_a? Array
            method = instance_method(key[0])
            method.bind(self).call key[1], un_modulo, method_name, block
          else
            method = instance_method(key)
            method.bind(self).call un_modulo, method_name, block
          end
        else
          un_modulo.send(:define_method, method_name, block) unless block.is_a? Array
        end
        end
      end
    end
    include un_modulo
  end
end
