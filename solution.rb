# NewRelic Metaprogramming Challange 2014
# Author: Jan Grodowski, jgrodowski@gmail.com, http://github.com/grodowski

require_relative 'lib/method_call_counter'

MethodCallCounter.start! ENV['COUNT_CALLS_TO']
at_exit { puts MethodCallCounter.status }
