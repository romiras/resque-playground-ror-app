class FooJob
  @queue = :foofoo

  def self.perform(args = {})
    Rails.logger.info "FooJob got #{args.inspect}"
    DATADOG_CLIENT.increment('foo', by: 1, tags: ['step:foo-self'])
    DATADOG_CLIENT.flush
    Rails.logger.info "FooJob DD-p-self #{DATADOG_CLIENT.telemetry.to_json}"
  end

end
