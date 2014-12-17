NewRelic Metaprogramming Challenge
===

*A Ruby script to count method invocations*

Sample usage:
---

```
# already defined instance method
COUNT_CALLS_TO="String#size" ruby -r ./solution.rb -e '3.times { "Abc".size }'
prints 'String#size was called 3 times'
```

```
# already defined class method

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

