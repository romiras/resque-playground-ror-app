require "resque/tasks"
require 'resque/scheduler/tasks'

desc 'Setup Resque'
task "resque:setup" => :environment do

  Resque.before_first_fork do
    # # Open the new separate log file
    # logfile = File.open(File.join(Rails.root, 'log', 'resque.log'), 'a')

    # # Activate file synchronization
    # logfile.sync = true

    Resque.logger.level = Logger::INFO
    Resque.logger.info "Resque Logger Initialized!"

    ActiveRecord::Base.send(:subclasses).each do |klass|
      unless klass.abstract_class?
        klass.primary_key
        klass.columns
      end
    end

  end

  Resque.before_fork = Proc.new {
    Rails.logger.info "=> Resque.before_fork called"
    p DATADOG_CLIENT.telemetry

    # ActiveRecord::Base.establish_connection
    # Resque.logger.info "ResqueLogger: establishing connection with ActiveRecord Base Class..."
  }

  Resque.after_fork = proc do
    Rails.logger.info "=> Resque.after_fork called"
    p DATADOG_CLIENT.telemetry
  end

  # Resque.worker_exit do
  #   Rails.logger.info "=> Resque.worker_exit called"
  # end

end

namespace :resque do
  task :setup_schedule => :setup do
    require 'resque-scheduler'

    # If you want to be able to dynamically change the schedule,
    # uncomment this line.  A dynamic schedule can be updated via the
    # Resque::Scheduler.set_schedule (and remove_schedule) methods.
    # When dynamic is set to true, the scheduler process looks for
    # schedule changes and applies them on the fly.
    # Note: This feature is only available in >=2.0.0.
    #Resque::Scheduler.dynamic = true

    # The schedule doesn't need to be stored in a YAML, it just needs to
    # be a hash.  YAML is usually the easiest.
    #Resque.schedule = YAML.load_file('config/resque_schedule.yml')

    # If your schedule already has +queue+ set for each job, you don't
    # need to require your jobs.  This can be an advantage since it's
    # less code that resque-scheduler needs to know about. But in a small
    # project, it's usually easier to just include you job classes here.
    # So, something like this:
    #require 'jobs'
  end

  task :scheduler_setup => :setup_schedule
end
