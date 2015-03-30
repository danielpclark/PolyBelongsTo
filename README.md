#PolyBelongsTo
[![Gem Version](https://badge.fury.io/rb/poly_belongs_to.svg)](http://badge.fury.io/rb/poly_belongs_to)
[![Code Climate](https://codeclimate.com/github/danielpclark/PolyBelongsTo/badges/gpa.svg)](https://codeclimate.com/github/danielpclark/PolyBelongsTo)
[![Build Status](https://travis-ci.org/danielpclark/PolyBelongsTo.svg)](https://travis-ci.org/danielpclark/PolyBelongsTo)
[![Test Coverage](https://codeclimate.com/github/danielpclark/PolyBelongsTo/badges/coverage.svg)](https://codeclimate.com/github/danielpclark/PolyBelongsTo)

**Original Purpose:** A standard way to check belongs_to relations on any belongs_to Object and let you check your DB Objects polymorphism in a more across-the-board meta-programatically friendly way.

PolyBelongsTo has grown into a powerful tool for working with all kinds of ActiveRecord relationships and situations.  PBT makes handling things in AR easier to deal with in a more generic way.  There are also some hierarchal tools provided which make coding with AR relationships all the more powerful.  See anything that's missing?  Please open an issue and suggest a feature!

#Installation

Just include it in your Gemfile and then run bundle:
```ruby
gem 'poly_belongs_to'
```

##Recommended Usage

#####On model class
```ruby
# Is Polymorphic?
MyOject.poly?
# => true
User.poly?
# => false
    
# Belongs To Relation Table
MyObject.pbt
# => :my_objectable
User.pbt
# => nil 

# Multiple Belongs To Relations
Tire.pbts
# => [:user, :car]

# Params name
MyObject.pbt_params_name
# => :my_objectable_attributes
MyObject.pbt_params_name(false)
# => :my_object
User.pbt_params_name
# => :user

# DB column names
MyObject.pbt_id_sym             
# => :my_objectable_id
MyObject.pbt_type_sym           
# => :my_objectable_type        # nil for non polymorphic Objects
```
#####On model instances
```ruby
# Belongs To Relations ID
MyObject.first.pbt_id
# => 123
    
# Polymorphic Belongs To Relations Type
MyObject.first.pbt_type
"User"                          # nil for non polymorphic Objects

# Get Parent Object (Works on all belongs_to Objects)
MyObject.first.pbt_parent
# => #<User id: 123 ... >

# Get Top Hierarchical Parent Object (Works on all belongs_to Objects)
MyObject.first.pbt_top_parent
# => #<User id: 123 ... >

# Mutliple Parent Objects (List of one item for Polymorphic, full list otherwise.)
Tire.first.pbt_parents
# => [#<User id: 123 ... >, #<Car id: 234 ... >]
```

##Also Available
```ruby
# --- Model Instances ---
# NOTE: touches db if object isn't already instantiated

# Is Polymorphic?
MyObject.new.poly?
# => true
User.first.poly?
# => false

# Belongs To Relation Table
MyObject.new.pbt
# => :my_objectable
User.first.pbt
# => nil

# Multiple Belongs To Relations
Tire.first.pbts
# => [:user, :car]

# Params name
MyObject.new.pbt_params_name
# => :my_objectable_attributes
MyObject.new.pbt_params_name(false)
# => :my_object
User.first.pbt_params_name
# => :user

# DB column names
MyObject.new.pbt_id_sym
# => :my_objectable_id
MyObject.new.pbt_type_sym       # nil for non polymorphic Objects
# => :my_objectable_type
```

##Internal Methods Available

```ruby
# For cleaning attributes for use with build
PolyBelongsTo::Pbt::AttrSanitizer[ obj ]

# Returns string of either 'child.build' or 'build_child'
PolyBelongsTo::Pbt::BuildCmd[ obj, child ]

# Returns has_one and has_many relationships for obj as an Array of symbols
PolyBelongsTo::Pbt::Reflects[ obj ]

# Returns Class Ojects for each has_one and has_many child associations
PolyBelongsTo::Pbt::ReflectsAsClasses[ obj ]

# Boolean of whether child object/class is a has(one/many) relationship to obj
PolyBelongsTo::Pbt::IsReflected[ obj, child ]

# Returns :singular if obj->child is has_one and :plural if obj->child is has_many
PolyBelongsTo::Pbt::SingularOrPlural[ obj, child ]

# Returns true if obj->child relationship is has_one
PolyBelongsTo::Pbt::IsSingular[ obj, child ]

# Returns true if obj->child relationship is has_many
PolyBelongsTo::Pbt::IsPlural[ obj, child ]

# Returns the symbol for the CollectionProxy the child belongs to in relation to obj
# NOTE: For has_one the symbol is not a CollectionProxy, but represents the instance
PolyBelongsTo::Pbt::CollectionProxy[ obj, child ]

# Always returns a collection proxy; fakes a collection proxy for has_one
PolyBelongsTo::Pbt::AsCollectionProxy[ obj, child ]

# Wrapper for has_one objects to be a collection proxy
PolyBelongsTo::FakedCollection.new(obj, child)

# Track which DB records have already been processed
PolyBelongsTo::SingletonSet.new
```
> In methods that have more than one type of ownership the order or precedence is
polymorphic relationships first, primary key next (or first reflection in lookup).


##Record Duplication

**This gives you the advantage of duplicating records regardless of polymorphic associations or
otherwise**.  You can duplicate a record, or use a self recursive command **pbt_deep_dup_build**
to duplicate a record and all of it's has_one/has_many children records at once.  Afterwards
be sure to use the save method.


####Known Issues
 - Carrierwave records won't duplicate.  To ensure that other records will still save and
prevent any rollback issues use .save(validate: false) ... I'm considering possible options
to remedy this and
other scenarios.

###How To Use

Use the dup/build methods as follows

```ruby
# If you were to create a new contact for example
contact = User.first.contacts.new

# This is just like contact.profile.build( { ... user's profile attributes ... } )
contact.pbt_dup_build( User.last.profile )

# Save it!
contact.save


# For a fully recursive copy do the same with pbt_deep_dup_build
contact.pbt_deep_dup_build( User.last.profile )

# Remeber to save!
contact.save
```

##Contributing

Feel free to fork and make pull requests.  Please bring up an issue before a pull
request if it's a non-fix change.  Please add applicable fixtures and tests for
any new features/implementations you add.

Thank You!


#License

The MIT License (MIT)

Copyright (C) 2015 by Daniel P. Clark

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
