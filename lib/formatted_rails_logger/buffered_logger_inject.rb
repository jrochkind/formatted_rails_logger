# intentionally raise if not already defined. For some reason I feel like
# doing this rather than declaring Rails a dependency. 
ActiveSupport::BufferedLogger.class 

# Rails 3.2 BufferedLogger has an internal @logger with a stdlib rails
# logger, but it doesn't expose ability to set a formatter. We've just
# got to do that, no problem. 
class ActiveSupport::BufferedLogger
  attr_accessor :formatter
  # use pure ruby class method, Rails provides ones with
  # better semantics for inheritance, but they keep changing
  # version to version, so nope. 
  class << self ; attr_accessor :default_formatter ; end
     
  def initialize(*args)
    super(*args)
    @log.formatter = self.class.default_formatter if self.class.default_formatter
  end
    
  def formatter=(formatter)
    @log.formatter = formatter
  end
  
  def formatter
    @log.formatter
  end
    
  
end

