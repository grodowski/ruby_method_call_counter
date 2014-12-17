# NewRelic Metaprogramming Challange 2014
# Author: Jan Grodowski, jgrodowski@gmail.com, http://github.com/grodowski

module MethodCallCounter
  def self.start!(method_sig)
    init_variables method_sig   
    klass = Object.const_get(@@watch_class)
    hook_into! klass
  rescue NameError => e
    # Hook into Object and wait for the target class to be loaded
    Object.class_eval do
      def self.inherited(subclass)
        super(subclass)
        MethodCallCounter.hook_into! subclass if subclass.to_s == @@watch_class
      end
    end
  end

  def self.status
    "#{@@watch_class}#{@@watch_type == :instance ? '#' : '.'}#{@@watch_name} has been invoked #{@@call_count} times"
  end
  
  def self.init_variables(method_sig)
    @@call_count = 0
    @@watch_type, sep = if method_sig =~ /#/ 
                          [:instance, '#']
                        else
                          [:class_method, '.']
                        end
    @@watch_class, @@watch_name = method_sig.split sep
  end
  
  def self.define_count_wrapper(klass)  
    # TODO: handle optional method arguments
    klass.send(:alias_method, :watched_method, @@watch_name)

    klass.class_eval do
      args = instance_method(@@watch_name.to_sym).parameters
      args_list = args.map { |arg| arg[1] }
      wrapper_method = Proc.new { |*args_list| @@call_count += 1; watched_method *args_list }
      define_method @@watch_name, wrapper_method 
      MethodCallCounter.debug 'Ready!'
    end
  end
    
  def self.hook_into!(klass)
    klass = klass.singleton_class if @@watch_type == :class_method
    debug "Initializing hooks: [class: #{klass}, watch_name: #{@@watch_name}, watch_type: #{@@watch_type}]"
    klass.class_eval do
      # setup the watch method - either directly or by waiting for the method
      # to be added using the method_added hook
    
      if method_defined?(@@watch_name)
        MethodCallCounter.debug "Adding count wrapper to #{@@watch_name}..."
        MethodCallCounter.define_count_wrapper klass
      else
        # need to add callback to method_added and define wrapper
        # when method is actually added to the target class
        @@_has_watch_method = false
    
        # we have to watch for method_added or singleton_method_added 
        # depending on the chosed method signature to watch for
        singleton = @@watch_type == :class_method ? 'singleton_' : nil
        klass.class_eval do
          receiver = singleton ? self : self.singleton_class
          receiver.send :define_method, "#{singleton}method_added" do |method_name|
            if method_name.to_s == @@watch_name && !@@_has_watch_method
              @@_has_watch_method = true
              MethodCallCounter.debug 'Adding watch method...'
              class_eval do 
                MethodCallCounter.define_count_wrapper klass
              end
            end
          end
        end
      
      end
  
      # setup hooks to wait for methods to be included
      # and wrap the module method
      if @@watch_type == :instance
        def self.include(included_module)
          if included_module.instance_methods.include?(@@watch_name.to_sym)
            included_module.class_eval do
              MethodCallCounter.define_count_wrapper self
            end
          end
          super(included_module)
        end
      end
  
      # setup hooks for methods to be extended
      # and wrap the module method
      if @@watch_type == :class_method
        def extend(extended_module)
          if extended_module.instance_methods.include?(@@watch_name.to_sym)
            extended_module.class_eval do 
              MethodCallCounter.define_count_wrapper self
            end
          end
          super(extended_module)
        end
      end
  
    end
    
  end
  
  def self.debug(output)
    puts output if ENV['DEBUG']
  end
  
end