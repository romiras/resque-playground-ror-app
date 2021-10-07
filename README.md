# resque-playground-ror-app

This is a RoR application playground for Resque jobs.

## Send StatsD metrics

Open terminal and run it to listen for StatsD (Ctrl-C to terminate it):

```bash
nc -u -l 127.0.0.1 8125
```

Open another terminal in root of project and run a Resque worker:

```bash
QUEUE=foofoo bin/rails resque:work
```

Then open another terminal in root of project and run:

```bash
tail -f log/datadog.log
```

Then open another terminal in root of project and within Rails console run:

```ruby
10.times {|n| Resque.enqueue FooJob, {foo: 'bar-%0d' % n} }
```
