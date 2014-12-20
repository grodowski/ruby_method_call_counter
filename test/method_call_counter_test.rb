require 'minitest/autorun'
require './lib/method_call_counter'

class SolutionTest < MiniTest::Test
  
  def test_instance_method
    MethodCallCounter.start! 'String#size'
    3.times { 'Hello, World'.size }
    assert_call_count 3
  end
  
  def test_class_method
    MethodCallCounter.start! 'Math.sin'
    eval "4.times { |n| Math.sin(n + 0.33) }"
    assert_call_count 4
  end
  
  def test_included_module
    MethodCallCounter.start! 'SolutionTest::B#foo'
    eval "module A; def foo; 'test'; end; end; class B; include A; end; 10.times { B.new.foo }"
    assert_call_count 10
  end
  
  def test_extended_module
    MethodCallCounter.start! 'SolutionTest::B.foo'
    eval 'module A; def foo; end; end; class B; extend A; end; 15.times{B.foo}'
    assert_call_count 15
  end
  
  def test_defined_instance_method
    MethodCallCounter.start! 'SolutionTest::Foo#bar'
    eval 'class Foo; def bar(str); str; end; end; 5.times { Foo.new.bar("Placki") }'
    assert_call_count 5
  end
  
  def test_defined_class_method
    MethodCallCounter.start! 'SolutionTest::Bar.bar'
    eval 'class Bar; def self.bar(str); str; end; end; 5.times { Bar.bar "Placki" }'
    assert_call_count 5
  end
  
  def test_dynamic_class_method
    MethodCallCounter.start! 'SolutionTest::Baz.bar'
    eval 'class Baz; end; a = Baz.new; Baz.class_eval do; define_singleton_method :bar do; "a"; end; end; 2.times { Baz.bar }'
    assert_call_count 2
  end
  
  def test_dynamic_instance_method
    MethodCallCounter.start! 'SolutionTest::Fooo#bar'
    eval 'class Fooo; end; a = Fooo.new; Fooo.class_eval do; define_method :bar do; "a"; end; end; 2.times { a.bar }'
    assert_call_count 2
  end
  
  private
  
  def assert_call_count(expected)
    assert_equal MethodCallCounter.class_variable_get(:@@call_count), expected
  end
end
