[![codebeat badge](https://codebeat.co/badges/47cc614e-abd2-48a1-b077-e913db33ca59)](https://codebeat.co/a/jan-grodowski/projects/ruby_method_call_counter-master)

MethodCallCounter
===

**Count invocations of an arbitraty method in Ruby** - `solution.rb` required on top of your host script expects the target method signature in an environment variable `COUNT_CALLS_TO`. Given `COUNT_CALLS_TO` has a correct method signature, the script will print the number of target method's invocations at the end of execution. 

Valid method signatures:
```
Math.sin
ActiveRecord::Base.connection
String#size
Foo.bar
Post#status
etc...
```

Example
---
Require on app load:
```
# spec_helper.rb
...
require_relative '../../solution.rb'
...
```

Execute a Ruby script with `COUNT_CALLS_TO` set to count invocations of `Hash#dup`
```
$ COUNT_CALLS_TO='Hash#dup' rspec spec/controllers
# some output
Hash#dup has been invoked 2768 times
```

To Do
---
* Exception handling
* Handle optional parameters more gracefully
* Add more tests

Feel free to **contribute** to this project by submitting pull requests! We can create something useful together, maybe :) 

