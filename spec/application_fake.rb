# Thank you!
# http://say26.com/rspec-testing-controllers-outside-of-a-rails-application
# https://github.com/hashrocket/decent_exposure/blob/ea02571938865fe60f86d2e4b37807062a3a7988/spec/fixtures/fake_rails_application.rb

require "rails"
require "active_support/all"
require "action_controller/railtie"
require "action_dispatch/railtie"

module Rails
  class FakeApplication
    def env_config; {} end

    def routes
      return @routes if defined?(@routes)
      @routes = ActionDispatch::Routing::RouteSet.new
    end
  end

  def self.application
    @app ||= FakeApplication.new
  end
end
