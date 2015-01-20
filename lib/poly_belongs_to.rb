module PolyBelongsTo
  extend ActiveSupport::Concern

  def pbt
    self.class.reflect_on_all_associations(:belongs_to).first.name
  end

  def poly?
    !!self.class.reflect_on_all_associations(:belongs_to).first.try {|i| i.options[:polymorphic] }
  end

  def pbt_id
    eval "self.#{pbt}_id"
  end

  def pbt_type
    eval "self.#{pbt}_type"
  end

end
