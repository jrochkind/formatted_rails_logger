# intentionally raise if not already defined. For some reason I feel like
# doing this rather than declaring Rails a dependency. 
ActiveSupport::BufferedLogger.class 

class ActiveSupport::BufferedLogger
  attr_accessor :formatter
  # use pure ruby class method, Rails provides ones with
  # better semantics for inheritance, but they keep changing
  # version to version, so nope. 
  class << self ; attr_accessor :default_formatter ; end
        

    
  
  # Have to over-ride/replace BufferedLogger's usual #add
  # to use formatter
  def add(severity, message = nil, progname = nil, &block)
    return if @level > severity
    message = (message || (block && block.call) || progname).to_s
    
    # our custom formatting
    message = format_message(format_severity(severity), Time.now, progname, message)
    
    # If a newline is necessary then create a new message ending with a newline.
    # Ensures that the original message is not mutated.
    message = "#{message}\n" unless message[-1] == ?\n
    buffer << message
    auto_flush
    message
  end
    
  protected
  
  # why does BufferedLogger not give us a way to translate from integer
  # constant to actual severity lable? argh. copied from Logger
  # Severity label for logging. (max 5 char)
  SEV_LABEL = %w(DEBUG INFO WARN ERROR FATAL UNKNOWN)
  def format_severity(severity)
    SEV_LABEL[severity] || 'UNKNOWN'
  end
  
  def format_message(severity, datetime, progname, msg)
    if formatter = (@formatter || self.class.default_formatter)
      formatter.call(severity, datetime, progname, msg)
    else
      msg
    end
  end
  
end

