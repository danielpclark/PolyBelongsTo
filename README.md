#PolyBelongsTo
[![Gem Version](https://badge.fury.io/rb/poly_belongs_to.svg)](http://badge.fury.io/rb/poly_belongs_to)
[![Code Climate](https://codeclimate.com/github/danielpclark/PolyBelongsTo/badges/gpa.svg)](https://codeclimate.com/github/danielpclark/PolyBelongsTo)
[![Build Status](https://travis-ci.org/danielpclark/PolyBelongsTo.svg)](https://travis-ci.org/danielpclark/PolyBelongsTo)

A standard way to check belongs_to relations on any belongs_to Object and will let you check your DB Objects polymorphism in a more across-the-board meta-programatically friendly way.

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
    
# Polymorphic Belongs To Relation Table
MyObject.pbt
# => :my_objectable
User.pbt
# => nil 

# Params name
MyObject.pbt_params_name
# => :my_objectable_attributes
MyObject.pbt_params_name(false)
# => :my_object
User.pbt_params_name
# => :user

# Polymorphic DB field names
MyObject.pbt_id_sym             
# => :my_objectable_id
MyObject.pbt_type_sym           
# => :my_objectable_type
```
#####On model instances
```ruby
# Polymorphic Belongs To Relations ID
MyObject.first.pbt_id
# => 123
    
# Polymorphic Belongs To Relations Type
MyObject.first.pbt_type
"User"                          # nil for non polymorphic Objects

# Get Parent Object (Works on all belongs_to Objects)
MyObject.first.pbt_parent
# => #<User id: 123 ... >
```

##Also Availabe
```ruby
# --- Model Instances ---
# NOTE: touches db if object isn't already instantiated

# Is Polymorphic?
MyObject.new.poly?
# => true
User.first.poly?
# => false

# Polymorphic Belongs To Relation Table
MyObject.new.pbt
# => :my_objectable
User.first.pbt
# => nil

# Params name
MyObject.new.pbt_params_name
# => :my_objectable_attributes
User.first.pbt_params_name
# => :user

# Polymorphic DB field names
MyObject.new.pbt_id_sym
# => :my_objectable_id
MyObject.new.pbt_type_sym       # nil for non polymorphic Objects
# => :my_objectable_type
```


And that's that!

#License

The MIT License (MIT)

Copyright (C) 2015 by Daniel P. Clark

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
