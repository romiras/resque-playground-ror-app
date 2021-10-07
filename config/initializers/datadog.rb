unless Rails.env.test? || ENV['DISABLE_DATADOG'].present?
  require 'logger'
  require 'resque'
  require 'ddtrace'
  require 'datadog/statsd'

  if Rails.env.development?
    Datadog.configure do |c|
      c.tracer enabled: false
      c.use :rails, service_name: "#{Rails.env}-rails-app"
      c.use :resque, { service_name: 'resque' }
      # c.use :http, service_name: 'http'
    end
  else
    Datadog.configure do |c|
      c.tracer enabled: false
      c.use :rails, service_name: "#{Rails.env}-rails-app"
      c.use :resque, { service_name: 'resque' }
      # c.use :http, service_name: 'http'
    end
  end

  # Create a DogStatsD client instance.
  DATADOG_CLIENT = Datadog::Statsd.new('localhost', 8125, logger: Logger.new('log/datadog.log'))

  DATADOG_CLIENT.increment('app_boot.count', tags: ["env:#{Rails.env}"])
  DATADOG_CLIENT.flush

  at_exit do
    # release resources used by the client instance
    DATADOG_CLIENT.close()
  end
end
