module PolyBelongsTo
  PbtAttrSanitizer = lambda {|pbt_obj|
    return pbt_obj.dup.attributes.delete_if {|ky,vl|
      [:created_at, :deleted_at, pbt_obj.pbt_id_sym, pbt_obj.pbt_type_sym].include? ky.to_sym
    } 
  }

  PbtBuildCmd = lambda {|has, item_to_duplicate|
    dup_name  = if has == :has_one
                  ActiveModel::Naming.singular(item_to_duplicate)
                else
                  ActiveModel::Naming.plural( item_to_duplicate )
                end
    return has.eql?(:has_one) ? "build_#{dup_name}" : has.eql?(:has_many) ? "#{dup_name}.build" : nil
  }
end
