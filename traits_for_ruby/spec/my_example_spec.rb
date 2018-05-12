require_relative '../src/trait'

describe 'trait' do
  Trait.define :MiTrait, {:metodo1 => proc{"Hola"}, :metodo2 => proc{|un_numero| un_numero * 0 + 42}}
  Trait.define :MiOtroTrait, {:metodo1 => proc {"kawabonga"}, :metodo3=>proc {"zaraza"}}
  Trait.define :UnTraitorazo, {:metodoA => proc{|una_palabra| "Hola" + "Mundo" + una_palabra}, :metodoB => proc{2+2}}

  #Traits for strategies
  Trait.define :PrimerTraitStrategy, {:metodo1 => proc{'kawabonga'}, :metodo2 => proc{'Zaraza'}}
  Trait.define :SegundoTraitStrategy, {:metodo2 => proc{'Hola mundo'}, :metodo3 => proc{'Deleted method'}}
  Trait.define :TercerTraitStrategy, {:metodo1 => proc{'kawabonga'}, :metodo2 => proc{5}}
  Trait.define :CuartoTraitStrategy, {:metodo2 => proc{10}, :metodo3 => proc{'Deleted method'}}

  it 'Alias de un metodo con el nombre de otro metodo' do
    expect{MiTrait << (:metodo2 > :metodo1)}.to raise_error('El nombre del metodo ya existe')
  end
    
    it 'add a trait to a class' do

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
    class Conflicto
      uses MiTrait + MiOtroTrait
    end

    o = Conflicto.new

    expect(o.metodo2(84)).equal?(42)
    expect(o.metodo3).equal?("zaraza")
    expect { o.metodo1 }.to raise_error(RuntimeError)

  end

  it 'Metodo no esta en el trait sustraccion' do
    expect {UnTraitorazo - :metodoC}.to raise_error(RuntimeError)
  end

  it 'symbol substraction of a class' do
    class TodoBienTodoLegal
      uses MiTrait + (MiOtroTrait - :metodo1)
    end

    o = TodoBienTodoLegal.new
    expect(o.metodo2(84)).equal? 42
    expect(o.metodo3).equal?("zaraza")
    expect(o.metodo1).equal?("Hola")
  end

  it 'rename symbols' do
    class ConAlias
      uses MiTrait << (:metodo1 > :saludo)
    end

    o = ConAlias.new
    expect(o.saludo).equal?("Hola")
    expect(o.metodo1).equal?("Hola")
    expect(o.metodo2(84)).equal?(42)
  end

  it 'execution of all conflicting messages' do
    class AClass
      strategy ({:execute_all=>[:metodo2]})
      uses PrimerTraitStrategy + SegundoTraitStrategy
    end


    o = AClass.new
    expect(o.metodo1).equal?('kawabonga')
    expect(o.metodo2).equal?('Zaraza')
    expect(o.metodo2).equal?('Hola mundo')
    expect(o.metodo3).equal?('Deleted method')
  end

  it 'execute function analogous to fold' do
    class AnotherClass
      strategy ({[:foldi,proc{|x,y| x+y}]=>[:metodo2]})
      uses TercerTraitStrategy + CuartoTraitStrategy
    end


    o = AnotherClass.new
    expect(o.metodo1).equal?('kawabonga')
    expect(o.metodo2).equal?(15)
    expect(o.metodo3).equal?('Deleted method')
  end

  it 'resolving through a condition' do
    class AAClas
      strategy [proc{|a_module, method_name, blocks| a_module.send(:define_method, method_name)do
        blocks[0].call+blocks[1].call>6
      end}]=>[:metodo2]
      uses TercerTraitStrategy + CuartoTraitStrategy
    end


    o = AAClas.new
    expect(o.metodo1).equal?('kawabonga')
    expect(o.metodo2).equal? true
    expect(o.metodo3).equal?('Deleted method')
  end


 end
