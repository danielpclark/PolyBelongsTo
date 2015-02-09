#Poly Belongs To
[![Code Climate](https://codeclimate.com/github/danielpclark/PolyBelongsTo/badges/gpa.svg)](https://codeclimate.com/github/danielpclark/PolyBelongsTo)

Is an ActiveRecord library which will let you check your DB Objects polymorphism in a more across-the-board
meta-programatically friendly way.

```ruby
# Is Polymorphic?
MyObject.new.poly?
# => true
MyOject.poly?
# => true
    
# Polymorphic Belongs To Relation Table
MyObject.new.pbt
# => :my_objectable
MyObject.pbt
# => :my_objectable
    
# Polymorphic Belongs To Relations ID
MyObject.new.pbt_id
# => 123
    
# Polymorphic Belongs To Relations Type
MyObject.new.pbt_type
"User"
```    

And that's that!

#Installation

Be in your Rails project directory.  Make sure you git is up to date with all your latest changes.  Then:

```shell
git fetch git@github.com:danielpclark/PolyBelongsTo.git install:pbt
git merge pbt
```

And then enter a description for this merge into your project.  Save the message, exit, and you're done!

#License

The MIT License (MIT)

Copyright (C) 2015 by Daniel P. Clark

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
