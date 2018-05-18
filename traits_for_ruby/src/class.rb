require_relative 'strategy'

class Class
  def strategy(strategy_hash)
    const_set :Strategy, strategy_hash
  end

  def uses(a_module)
    include Strategy
    if const_get(:Strategy) == Strategy
      method = instance_method(:resolve_with_default)
      new_module = method.bind(self).call a_module
      include new_module
    else
      method = instance_method(:apply_each_strategy)
      new_module = method.bind(self).call const_get(:Strategy), a_module
      include new_module
    end
  end
end

