#
# A Logger::Formatter that includes timestamp and severity, and works
# well with Rails, taking account of preceding newlines in msg for spacing.
class FormattedRailsLogger::Formatter
  # Unlike Logger, not seeing a need to include the PID, the progname, 
  # or the Severity twice. 
  @@format_str = "[%s] %5s  %s"
  @@datetime_format = nil 

  def call(severity, time, progname, msg) 
    msg = "" if msg.nil? # need to manipulate it as string

    # Rails 3.2 seems to automatically add a newline, for consistency
    # we will too. 
    msg += "\n"    
    
    # if the msg is blank, meant to create a newline, then
    # just output it without any preliminaries, to keep the
    # newline as seperator. Also return quick for nil msg, to
    # avoid causing problems with later logic. 
    return msg if msg.blank?

    
    # see no need for micro-seconds like in Logger, milis suffices. 
    # No idea why documented %L and other such useful things
    # do not work in strftime. 
    formatted_time = if @@datetime_format
      time.strftime(@@datetime_format)
    else
      time.strftime("%Y-%m-%d %H:%M:%S.") << time.usec.to_s[0..2].rjust(3)
    end

    # Rails likes to log with some preceding newlines for spacing in the
    # logfile. We want to preserve those when present, 
    # but prefix actual content with our prefix.
    matchData = ( /\A(\n*)/.match(msg)  )    
    

    matchData[0] + (@@format_str % [formatted_time, severity, matchData.post_match])
  end

end

