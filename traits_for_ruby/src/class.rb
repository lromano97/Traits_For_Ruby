class Symbol
  def >(nuevo_nombre)
    mapa_del_orto = {self => nuevo_nombre}
    mapa_del_orto
   end
end

class Class

  def uses(_unModulo)
    include(_unModulo)
  end

end

