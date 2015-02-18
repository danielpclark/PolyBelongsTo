module PolyBelongsTo
  module Pbt
    AttrSanitizer = lambda {|obj|
      obj.dup.attributes.delete_if {|ky,vl|
        [:created_at, :updated_at, :deleted_at, obj.pbt_id_sym, obj.pbt_type_sym].include? ky.to_sym
      } 
    }

    BuildCmd = lambda {|obj, child|
      dup_name = "#{CollectionProxy[obj,child]}"
      IsSingular[obj, child] ? "build_#{dup_name}" : IsPlural[obj, child] ? "#{dup_name}.build" : nil
    }

    Reflects = lambda {|obj|
      [:has_one, :has_many].map { |has|
        eval(obj.class.name).reflect_on_all_associations(has).map(&:name).map(&:to_sym)
      }.flatten
    }
    
    IsReflected = lambda {|obj,child|
      !!SingularOrPlural[obj, child]
    }

    SingularOrPlural = lambda {|obj, child|
      reflects = Reflects[obj]
      if reflects.include?(ActiveModel::Naming.singular(child).to_sym)
        :singular
      elsif reflects.include?(ActiveModel::Naming.plural(child).to_sym)
        :plural
      else
        nil
      end
    }

    IsSingular = lambda {|obj, child|
      eval(obj.class.name).reflect_on_all_associations(:has_one).
        map(&:name).map(&:to_sym).include? ActiveModel::Naming.singular(child).to_sym
    }

    IsPlural = lambda {|obj,child|
      eval(obj.class.name).reflect_on_all_associations(:has_many).
        map(&:name).map(&:to_sym).include? ActiveModel::Naming.plural(child).to_sym
    }

    CollectionProxy = lambda {|obj, child|
      reflects = Reflects[obj]
      proxy = ActiveModel::Naming.singular(child).to_sym
      if reflects.include? proxy
        return proxy
      end
      proxy = ActiveModel::Naming.plural(child).to_sym
      if reflects.include? proxy
        proxy
      else
        nil
      end
    }
  end
end
