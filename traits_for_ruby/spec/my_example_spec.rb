require_relative '../src/trait'

describe 'trait' do

  it 'add a trait to a class' do

    Trait.define :MiTrait, {:metodo1 => proc{"Hola"}, :metodo2 => proc{|un_numero| un_numero * 0 + 42}}

    class MiClase
      uses MiTrait
      def metodo1
        "mundo"
      end
    end

    o = MiClase.new
    expect(o.metodo1).equal?("mundo")
    expect(o.metodo2(33)).equal?(42)
  end

  it 'add two traits to a class' do
    Trait.define :MiTrait, {:metodo1 => proc{"Hola"}, :metodo2 => proc{|un_numero| un_numero * 0 + 42}}
    Trait.define :MiOtroTrait, {:metodo1 => proc {"kawabonga"}, :metodo3=>proc {"zaraza"}}

    class Conflicto
      uses MiTrait + MiOtroTrait
    end

    o = Conflicto.new

    expect(o.metodo2(84)).equal?(42)
    expect(o.metodo3).equal?("zaraza")
    expect { o.metodo1 }.to raise_error(RuntimeError)

  end

  it 'symbol substraction of a class' do
    Trait.define :MiTrait, {:metodo1 => proc{"Hola"}, :metodo2 => proc{|un_numero| un_numero * 0 + 42}}
    Trait.define :MiOtroTrait, {:metodo1 => proc {"kawabonga"}, :metodo3=>proc {"zaraza"}}

    class TodoBienTodoLegal
      uses MiTrait + (MiOtroTrait - :metodo1)
    end

    o = TodoBienTodoLegal.new
    expect(o.metodo2(84)).equal? 42
    expect(o.metodo3).equal?("zaraza")
    expect(o.metodo1).equal?("Hola")
  end

  it 'rename symbols' do
    Trait.define :MiTrait, {:metodo1 => proc{"Hola"}, :metodo2 => proc{|un_numero| un_numero * 0 + 42}}

    class ConAlias
      uses MiTrait << (:metodo1 > :saludo)
    end

    o = ConAlias.new
    expect(o.saludo).equal?("Hola")
    expect(o.metodo1).equal?("Hola")
    expect(o.metodo2(84)).equal?(42)
  end
end