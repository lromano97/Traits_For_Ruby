module Algebra
  include Strategy
  def +(a_trait)
    new_trait = Module.new
    my_methods = const_get(:Methods).clone
    its_methods = a_trait.const_get(:Methods).clone
    new_hash = my_methods.merge(its_methods){ |key, new_value, old_value|
      [new_value, old_value].flatten
    }
    new_trait.const_set :Methods, new_hash
    new_trait
  end

  def -(a_method)
    raise "El metodo no existe" unless
        const_get(:Methods).key? a_method
    new_trait = Module.new
    new_hash = const_get(:Methods).clone
    new_trait.const_set :Methods, new_hash
    new_trait.const_get(:Methods).delete(a_method)
    new_trait
  end

  def <<(hash_with_names)
    hash_with_names.each do |old_name, new_name|
      raise "El nombre del metodo ya existe" if const_get(:Methods).key? new_name
      raise "El metodo a modificar no existe" unless const_get(:Methods).key? old_name
      const_get(:Methods)[new_name] = const_get(:Methods)[old_name]
    end
    self
  end
end