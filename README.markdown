# FormattedRailsLogger

Monkey-patches Rails BufferedLogger (the standard Rails logger) to accept a formatter just like ruby Logger does. Provides a formatter that includes timestamp and severity in logs, while taking account of Rails habit of making space in the logfile by adding newlines to the beginning of log message. 

It's only 80 lines of verbose code.  I'd think a bazillion people would have done this before, but I didn't see any other gems to do it simply and flexibly, sorry for any duplication. 

## How to use

Should work for both Rails2 and Rails3. 

Include the formatted_rails_logger gem in your project as appropriate for your Rails version. 

I don't like magic, so it doesn't actually do anything just to include the gem. Instead create an initializer, say config/initializers/logging.rb:

    require 'formatted_rails_logger'
    
    #monkey-patch BufferedLogger
    FormattedRailsLogger.patch_rails
    
    #Use the supplied formatter that includes timestamp and severity
    Rails.logger.formatter = FormattedRailsLogger::Formatter.new
    
You can of course also write your own formatter, which is just any
object that responds to #call(severity, datetime, progname, msg) . A proc or lambda with those arguments works. See ruby [Logger](http://www.ruby-doc.org/stdlib/libdoc/logger/rdoc/classes/Logger.html) ([source](https://github.com/ruby/ruby/blob/trunk/lib/logger.rb)).  
    
There may be some fancier way to do things with Rails3 involving config.logger, I don't know, I'm in the middle of several rails 2->3 transitions, and needed something that would work with both, and this method should. 

## What it does

It monkey patches BufferedLogger to accept a #formatter just like standard ruby Logger. Had to copy and paste the whole #add method to monkey patch it, sorry. Hopefully it won't change much in the foreseeable future. 

Then it provides a Logger-style formatter object that formats the way I'd like. It's got a timestamp, I decided that miliseconds were probably useful but Logger's default of including microseconds was a ridiculous waste of screen columns. I decided [Logger](https://github.com/ruby/ruby/blob/trunk/lib/logger.rb)'s default inclusion of PID and progname weren't worth the columns, and I have no idea why Logger's default formatter includes the severity twice in two different ways, so I didn't do that. 

I did more or less copy the format that my 2.3.x Rails app outputs (from WebBrick?) before Rails hijacks with the buffered logger. But with miliseconds. 

I did use a regexp to look for newlines at the very beginning of a log message, and insert the timestamp/severity _after_ those newlines, so they can still serve the desired spacing function and everything looks how you'd want. 

    [2011-08-04 15:29:21.606]  INFO  Completed in 1811ms (View: 1392, DB: 204) | 200 OK [http://X.X.X.edu/catalog?q=anarchy&search_field=all_fields]


    [2011-08-04 15:29:21.834]  INFO  Processing CatalogController#range_limit (for X.X.X.X at 2011-08-04 15:29:21) [GET]


## Things I'm Baffled About

* Why has Rails always thought it better to exclude timestamps and severity from logfiles? Me, I need to be able to grep logfiles for "ERROR" or "FATAL" or "WARN" to see how my app's doing, and I need to be able to have timestamps to correlate human observed problems to the logs. Am I really alone here? 

* Why does Rails BufferedLogger not provide the same formatter functionality a usual ruby Logger, either by sub-classing Logger, or duck-typing the formatter functionality too?  

* Why does ruby 1.8.7 Time.strftime not accept an %L formatting string, even though the [documentation](http://www.ruby-doc.org/core/classes/Time.html#M000392) says it should? Did they fix this in 1.9? I don't know. 

## Things I didn't do

* No, there are no unit tests. I just hacked this out cause I was sick of Rails logging. If you wanted to help out and add em, that'd be great.

* I sort of feel like someone should actually propose this as a patch to Rails itself (at least the part where BufferedLogger can take a #formatter), but I lack the psychic energy, and it still wouldn't help me right now on current stable versions of Rails. 


