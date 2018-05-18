module Algebra
  include Strategy
  def +(a_trait)
    new_trait = Module.new
    new_trait.include Algebra
    new_trait.singleton_class.include Algebra
    my_module_methods = instance_methods(false)
    my_methods = const_get(:Methods).clone
    if(my_module_methods!=[])
      my_module_methods.each do |method_name|
        my_module_method_block = instance_method(method_name)
        my_methods[method_name] = my_module_method_block
      end
    end
    a_trait_methods = a_trait.instance_methods(false)
    its_methods = a_trait.const_get(:Methods).clone
    if(a_trait_methods!=[])
      a_trait_methods.each do |method_name|
        a_trait_method_block = a_trait.instance_method(method_name)
        its_methods[method_name] = a_trait_method_block
      end
    end
    new_hash = my_methods.merge(its_methods){ |_key, new_value, old_value|
      [new_value, old_value].flatten
    }
    new_trait.const_set :Methods, new_hash
    new_trait
  end

  def -(a_method)
    raise "El metodo no existe" unless ((const_get(:Methods).key? a_method) || (self.instance_methods(false).include? a_method))
    new_trait = Module.new
    new_trait.include Algebra
    new_trait.singleton_class.include Algebra
    new_hash = const_get(:Methods).clone
    new_trait.const_set :Methods, new_hash
    new_trait.const_get(:Methods).delete(a_method)
    new_trait
  end

  def <<(hash_with_names)
    hash_with_names.each do |old_name, new_name|
      raise "El nombre del metodo ya existe" if ((const_get(:Methods).key? new_name) || (self.instance_methods(false).include? new_name))
      raise "El metodo a modificar no existe" unless ((const_get(:Methods).key? old_name) || (self.instance_methods(false).include? old_name))
      if(const_get(:Methods).key? old_name)
        const_get(:Methods)[new_name] = const_get(:Methods)[old_name]
      else
        const_get(:Methods)[new_name] = self.instance_method(old_name)
      end
    end
    self
  end
end