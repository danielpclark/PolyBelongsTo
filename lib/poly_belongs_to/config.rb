class PolyBelongsTo::PbtConfig < OpenStruct
  def fetch(key, &block)
    @table.fetch(key.to_sym, &block)
  end

  def delete(name)
    @table.delete name.to_sym
  end
end
