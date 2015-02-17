module PolyBelongsTo
  module Pbt
    AttrSanitizer = lambda {|pbt_obj|
      return pbt_obj.dup.attributes.delete_if {|ky,vl|
        [:created_at, :deleted_at, pbt_obj.pbt_id_sym, pbt_obj.pbt_type_sym].include? ky.to_sym
      } 
    }

    BuildCmd = lambda {|has, item_to_build|
      dup_name  = if has == :has_one
                    ActiveModel::Naming.singular(item_to_build)
                  else
                    ActiveModel::Naming.plural( item_to_build )
                  end
      return has.eql?(:has_one) ? "build_#{dup_name}" : has.eql?(:has_many) ? "#{dup_name}.build" : nil
    }

    SingleOrPlural = lambda {||
    }

    CollectionProxy = lambda {||
    }
  end
end
