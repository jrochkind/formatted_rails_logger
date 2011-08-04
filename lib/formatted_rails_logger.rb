require "formatted_rails_logger/version"

module FormattedRailsLogger
  def self.patch_rails
    load File.expand_path("../formatted_rails_logger/buffered_logger_inject.rb", __FILE__)
  end
end
