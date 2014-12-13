# NewRelic Metaprogramming Challange 2014
# Author: Jan Grodowski, jgrodowski@gmail.com, http://github.com/grodowski

# Usage:
# COUNT_CALLS_TO="String#size" ruby -r ./solution.rb -e '3.times { "Abc".size }'
# COUNT_CALLS_TO='String#size' ruby -r ./solution.rb -e '(1..100).each{|i| i.to_s.size if i.odd? }'
# COUNT_CALLS_TO='B#foo' ruby -r ./solution.rb -e 'module A; def foo; end; end; class B; include A; end; 10.times{B.new.foo}'

# Valid COUNT_CALLS_TO values:
# 'String.count'
# 'ActiveRecord::Base.connection'
# 'String#count'

argument_str = ENV['COUNT_CALLS_TO']

arr_hash = argument_str.split('#')
arr_dot = argument_str.split('.')

$call_count = 0
$watch_class, $watch_name, $watch_type = if arr_hash.size == 2
  arr_hash << :instance
elsif arr_dot.size == 2
  arr_dot << :singleton
else
  raise 'COUNT_CALLS_TO has invalid format'
end
  
begin   
  klass = Object.const_get($watch_class)
rescue NameError => e
  klass = Object.const_set($watch_class, Class.new)
end

if $watch_type == :singleton
  klass = klass.singleton_class
end

def define_count_wrapper
  # TODO: handle 0..* input parameters and pass
  # them to the wrapper method as block args
  send(:alias_method, :watched_method, $watch_name)

  class_eval do 
    define_method $watch_name do 
      $call_count += 1
      watched_method
    end
  end
end

klass.class_eval do
  # setup the watch method - either directly or by waiting for the method
  # to be added using the method_added hook
    
  if method_defined?($watch_name)
    define_count_wrapper
  else
    # need to add callback to method_added and define wrapper
    # when method is actually added to the target class
    class_variable_set(:@@has_watch_method, false)
    def self.method_added(method_name)
      if method_name.to_s == $watch_name && !self.class_variable_get(:@@has_watch_method)
        self.class_variable_set(:@@has_watch_method, true)
        puts 'Adding watch method...'        
        class_eval do 
          define_count_wrapper
        end
      end
    end
  end

  # setup hooks to wait for methods to be included
  # and wrap the module method
  if $watch_type == :instance
    def self.include(included_module)
      if included_module.instance_methods.include?($watch_name.to_sym)
        included_module.class_eval do
          define_count_wrapper
        end
      end
      super(included_module)
    end
  end
  
  # setup hooks for methods to be extended
  # and wrap the module method
  if $watch_type == :singleton
    def extend(extended_module)
      if extended_module.instance_methods.include?($watch_name.to_sym)
        extended_module.class_eval do 
          define_count_wrapper
        end
      end
      super(extended_module)
    end
  end
  
end

at_exit do 
  puts "The method #{$watch_class}#{$watch_type == :instance ? '#' : '.'}#{$watch_name} has been invoked #{$call_count} times"
end

