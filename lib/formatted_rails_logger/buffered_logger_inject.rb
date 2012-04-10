# intentionally raise if not already defined. For some reason I feel like
# doing this rather than declaring Rails a dependency.
ActiveSupport::BufferedLogger.class

# Rails 3.2 BufferedLogger has an internal @logger with a stdlib rails
# logger, but it doesn't expose ability to set a formatter. We've just
# got to do that, no problem.
class ActiveSupport::BufferedLogger
  attr_accessor :formatter

  def formatter=(formatter)
    @log.formatter = formatter
  end

  def formatter
    @log.formatter
  end


end

