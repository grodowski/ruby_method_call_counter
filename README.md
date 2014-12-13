NewRelic Metaprogramming Challenge
===

*A Ruby script to count method invocations*

Sample usage:
---

```
COUNT_CALLS_TO="String#size" ruby -r ./solution.rb -e '3.times { "Abc".size }'
prints 'String#size was called 3 times'
```

```
COUNT_CALLS_TO='B#foo' ruby -r ./solution.rb -e 'module A; def foo; end; end; class B; include A; end; 10.times{B.new.foo}'
prints 'B#foo was called 10 times'
```

```
COUNT_CALLS_TO='B.foo' ruby -r ./solution.rb -e 'module A; def foo; end; end; class B; extend A; end; 15.times{B.foo}'
prints B.foo was called 15 times'
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

