require_relative '../src/trait'

describe 'trait' do

  # it 'Renombrar con nombres de simbolos existentes' do
  #  Trait.define :UnTraitorazo, {:metodoA => proc{|una_palabra| "Sexo" + "Anal" + una_palabra}, :metodoB => proc{2+2}}
  #
  # class UnaClase
  #   uses  UnTraitorazo << (:metodoB > :metodoA)
  # end
  #
  # objeto = UnaClase.new
  #
  # expect{objeto.metodoA}.to raise_error(RuntimeError)
  # end

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

  it 'Metodo no esta en el trait sustraccion' do
    Trait.define :UnTraitorazo, {:metodoA => proc{|una_palabra| "Sexo" + "Anal" + una_palabra}, :metodoB => proc{2+2}}

    class UnaClase
      uses  UnTraitorazo - :metodoC
    end

    objeto = UnaClase.new

    expect{objeto.metodoC}.to raise_error(RuntimeError)
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
      
   it 'execution of all conflicting messages' do
    Trait.define :MiTrait, {:metodo1 => proc{"kawabonga"}, :metodo2 => proc{puts "Zaraza"}}
    Trait.define :MiOtroTrait, {:metodo2 => proc{puts "Hola mundo"}, :metodo3 => proc{puts "Deleted method"}}

    class UnaClase
      strategy ({:execute_all=>[:metodo2]})
      uses MiTrait + MiOtroTrait
    end


    o = UnaClase.new
    expect(o.metodo1).equal?("kawabonga")
    expect(o.metodo2).equal?("Zaraza")
    expect(o.metodo2).equal?("Hola mundo")
    expect(o.metodo3).equal?("Deleted method")
  end

  it 'execute function analogous to the fold' do
    Trait.define :MiTrait, {:metodo1 => proc{"kawabonga"}, :metodo2 => proc{5}}
    Trait.define :MiOtroTrait, {:metodo2 => proc{10}, :metodo3 => proc{puts "Deleted method"}}

    class UnaClase
      strategy ({[:foldi,proc{|x,y| puts (x+y)}]=>[:metodo2]})
      uses MiTrait + MiOtroTrait
    end


    o = UnaClase.new
    expect(o.metodo1).equal?("kawabonga")
    expect(o.metodo2).equal?(15)
    expect(o.metodo3).equal?("Deleted method")
  end

 end
