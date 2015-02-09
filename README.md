#PolyBelongsTo
[![Gem Version](https://badge.fury.io/rb/poly_belongs_to.svg)](http://badge.fury.io/rb/poly_belongs_to)
[![Code Climate](https://codeclimate.com/github/danielpclark/PolyBelongsTo/badges/gpa.svg)](https://codeclimate.com/github/danielpclark/PolyBelongsTo)

Is an ActiveRecord library which will let you check your DB Objects polymorphism in a more across-the-board
meta-programatically friendly way.

#Installation

### Gem

Just include it in your Gemfile and then run bundle:
```ruby
gem 'poly_belongs_to'
```

###Merge via git
Be in your Rails project directory.  Make sure you git is up to date with all your latest changes.  Then:

```shell
git fetch git@github.com:danielpclark/PolyBelongsTo.git install:pbt
git merge pbt
```

And then enter a description for this merge into your project.  Save the message, exit, and you're done!

#Example Usage

```ruby
# Is Polymorphic?
MyObject.new.poly?
# => true
MyOject.poly?
# => true
User.first.poly?
# => false
User.poly?
# => false
    
# Polymorphic Belongs To Relation Table
MyObject.new.pbt
# => :my_objectable
MyObject.pbt
# => :my_objectable
User.first.pbt
# => nil
User.pbt
# => nil
    
# Polymorphic Belongs To Relations ID
MyObject.first.pbt_id
# => 123
    
# Polymorphic Belongs To Relations Type
MyObject.first.pbt_type
"User"
```    

And that's that!

#TODO

Basic specs

#License

The MIT License (MIT)

Copyright (C) 2015 by Daniel P. Clark

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
