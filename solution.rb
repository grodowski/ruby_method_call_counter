# NewRelic Metaprogramming Challange 2014
# Author: Jan Grodowski, jgrodowski@gmail.com, http://github.com/grodowski

# Usage:
# COUNT_CALLS_TO="String#size" ruby -r ./solution.rb -e '3.times { "Abc".size }'
# COUNT_CALLS_TO='String#size' ruby -r ./solution.rb -e '(1..100).each{|i| i.to_s.size if i.odd? }'
#
#

# Valid COUNT_CALLS_TO values:
# 'String.count'
# 'ActiveRecord::Base.connection'
# 'String#count'

argument_str = ENV['COUNT_CALLS_TO']

arr_hash = argument_str.split('#')
arr_dot = argument_str.split('.')

$watch_count = 0
$watch_class, $watch_name = if arr_hash.size == 2
  arr_hash
elsif arr_dot.size == 2 # class method case
  arr_dot
else
  raise 'COUNT_CALLS_TO has invalid format!'
end
 
at_exit do 
  puts "The method #{$watch_class}##{$watch_name} has been invoked #{$watch_count} times"
end
 
begin   
  klass = Object.const_get($watch_class)
rescue NameError => e
  klass = Object.const_set($watch_class, Class.new)
end

def define_class_count_wrapper
  puts "Defining wrapper method for #{self}"
  alias_method :watched_method, $watch_name  

  class_eval do 
    define_method $watch_name do 
      $watch_count += 1
      watched_method
    end
  end
end

def define_module_count_wrapper 
  puts "Defining wrapper method for #{self}"
  module_eval do 
    alias_method :watched_method, $watch_name
    define_method $watch_name do 
      $watch_count += 1
      watched_method
    end
  end
end

klass.class_eval do
  # setup the watch method - either directly or by waiting for the method
  # to be added using the method_added hook
  class_variable_set(:@@has_watch_method, false)
  if method_defined?($watch_name)
    
    # add method wrapper to count invocations
    define_class_count_wrapper
  
  else
    
    # add callback to method_added and define wrapper
    def self.method_added(method_name)
      if method_name.to_s == $watch_name && !self.class_variable_get(:@@has_watch_method)
        self.class_variable_set(:@@has_watch_method, true)
        puts 'Adding watch method...'        
        class_eval do 
          define_class_count_wrapper
        end
      end
    end   

  end
  
  # setup hooks to wait for methods to be included
  def self.include(included_module)
    puts 'Including methods from module...'
    if included_module.instance_methods.include?($watch_name.to_sym)
      included_module.module_eval do 
        define_module_count_wrapper
      end
    end
    super(included_module)
  end
  
  # setup hooks for methods to be extended
  def self.extend(extended_module)
    
  end
  
end
