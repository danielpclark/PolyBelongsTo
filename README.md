#Poly Belongs To

Is an ActiveRecord library which will let you check you DB Objects polymorphism in a more across-the-board
meta-programatically friendly way.

    # Is Polymorphic?
    MyObject.new.poly?
    # => true
    
    # Polymorphic Belongs To Relation Table
    MyObject.new.pbt
    # => :my_objectable
    
    # Polymorphic Belongs To Relations ID
    MyObject.new.pbt_id
    # => 123
    
    # Polymorphic Belongs To Relations Type
    MyObject.new.pbt_type
    "User"
    
And that's that!

#License

MIT License