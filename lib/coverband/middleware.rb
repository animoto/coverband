module Coverband
  class Middleware

    def initialize(app, options = {})
      @app = app

      @force_coverage_checker = options['force_coverage_checker']
    end

    def call(env)
      Coverband::Base.instance.configure_sampling(force_coverage?(env))
      Coverband::Base.instance.record_coverage
      @app.call(env)
    ensure
      Coverband::Base.instance.report_coverage
    end

    private

    def force_coverage?(env)
      !!(@force_coverage_checker && @force_coverage_checker.call(env))
    end
  end
end
