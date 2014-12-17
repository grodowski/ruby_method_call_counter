NewRelic Metaprogramming Challenge
===

**A Ruby script to count method invocations**

Sample uses:
---

```
# already defined instance method
COUNT_CALLS_TO="String#size" ruby -r ./solution.rb -e '3.times { "Abc".size }'
prints 'String#size was called 3 times'
```

```
# already defined class method
COUNT_CALLS_TO="Math.sin" ruby -r ./solution.rb -e '4.times { |n| puts Math.sin(n + 0.33) }'
```

```
# instance method from included module
COUNT_CALLS_TO='B#foo' ruby -r ./solution.rb -e 'module A; def foo; end; end; class B; include A; end; 10.times{B.new.foo}'
prints 'B#foo was called 10 times'
```

```
# class method from extended module
COUNT_CALLS_TO='B.foo' ruby -r ./solution.rb -e 'module A; def foo; end; end; class B; extend A; end; 15.times{B.foo}'
prints B.foo was called 15 times'
```

```
# class method defined in the host script
COUNT_CALLS_TO='Foo.bar' ruby -r ./solution.rb -e 'class Foo; def self.bar(str); puts str; end; end; 5.times { Foo.bar "Placki" }'
```


```
# instance method define in the host script
COUNT_CALLS_TO='Foo#bar' ruby -r ./solution.rb -e 'class Foo; def bar(str); puts str; end; end; 5.times { Foo.new.bar("Placki") }'
```

```
# instance method defined dynamically
COUNT_CALLS_TO="Foo#bar" ruby -r ./solution.rb -e 'class Foo; end; a = Foo.new; Foo.class_eval do; define_method :bar do; puts "a"; end; end; 2.times { a.bar }'
```

```
# class method defined dynamically
COUNT_CALLS_TO="Foo.bar" ruby -r ./solution.rb -e 'class Foo; end; a = Foo.new; Foo.class_eval do; define_singleton_method :bar do; puts "a"; end; end; 2.times { Foo.bar }'
```

Valid `COUNT_CALLS_TO` values:
---
```
String.count
ActiveRecord::Base.connection
String#count
```

To Do:
---
* Accept methods with parameters
* Add tests

