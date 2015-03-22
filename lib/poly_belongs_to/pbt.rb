module PolyBelongsTo
  module Pbt
    AttrSanitizer = lambda {|obj|
      return {} unless obj
      obj.dup.attributes.delete_if {|ky,vl|
        [:created_at, :updated_at, :deleted_at, obj.pbt_id_sym, obj.pbt_type_sym].include? ky.to_sym
      } 
    }

    BuildCmd = lambda {|obj, child|
      return nil unless obj && child
      dup_name = CollectionProxy[obj,child]
      IsSingular[obj, child] ? "build_#{dup_name}" : IsPlural[obj, child] ? "#{dup_name}.build" : nil
    }

    Reflects = lambda {|obj|
      return [] unless obj
      [:has_one, :has_many].map { |has|
        obj.class.name.constantize.reflect_on_all_associations(has).map(&:name).map(&:to_sym)
      }.flatten
    }

    ReflectsAsClasses = lambda {|obj|
      Reflects[obj].map {|ref|
        (obj.send(ref).try(:klass) || obj.send(ref).class).name.constantize
      }
    }
    
    IsReflected = lambda {|obj,child|
      !!SingularOrPlural[obj, child]
    }

    SingularOrPlural = lambda {|obj, child|
      return nil unless obj && child
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
      SingularOrPlural[obj, child] == :singular
    }

    IsPlural = lambda {|obj,child|
      SingularOrPlural[obj, child] == :plural
    }

    CollectionProxy = lambda {|obj, child|
      return nil unless obj && child
      reflects = Reflects[obj]
      proxy = ActiveModel::Naming.singular(child).to_sym
      return proxy if reflects.include? proxy
      proxy = ActiveModel::Naming.plural(child).to_sym
      reflects.include?(proxy) ? proxy : nil
    }
  
    AsCollectionProxy = lambda {|obj, child|
      return [] unless obj && child
      reflects = Reflects[obj]
      proxy = ActiveModel::Naming.singular(child).to_sym
      return PolyBelongsTo::FakedCollection.new(obj, child) if reflects.include? proxy
      proxy = ActiveModel::Naming.plural(child).to_sym
      reflects.include?(proxy) ? obj.send(PolyBelongsTo::Pbt::CollectionProxy[obj, child]) : []
    }
  end
  
end
