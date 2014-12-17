require 'minitest/autorun'
require './lib/method_call_counter'

class SolutionTest < MiniTest::Test
  def test_empty_args
    
  end
  
  def test_instance_method
    MethodCallCounter.start! 'String#size'
    3.times { 'Hello, World'.size }
    assert_call_count 3
  end
  
  def test_class_method
    MethodCallCounter.start! 'Math.sin'
    4.times { |n| Math.sin(n + 0.33) }
    assert_call_count 4
  end
  
  def test_included_module
    MethodCallCounter.start! 'B#foo'
    # TODO
    # module A
    #   def foo
    #   end
    # end
    #
    # class B
    #   include A
    # end
    # 10.times{B.new.foo}
    #
    #assert_call_count 10
  end
  
  def test_extended_module
    
  end
  
  def test_defined_instance_method
    
  end
  
  def test_defined_class_method
    
  end
  
  def test_dynamic_instance_method
    
  end
  
  private
  
  def assert_call_count(expected)
    assert_equal MethodCallCounter.class_variable_get(:@@call_count), expected
  end
end
