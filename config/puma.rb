# frozen_string_literal: true

# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
#
threads Settings.puma.rails_threads, Settings.puma.rails_threads

# Specifies the `worker_timeout` threshold that Puma will use to wait before
# terminating a worker in development environments.
#
worker_timeout Settings.puma.worker_timeout

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
#
port ENV.fetch('PORT', 3000)

# Specifies the `environment` that Puma will run in.
#
environment ENV.fetch('RAILS_ENV', 'development')

# Specifies the `pidfile` that Puma will use.
pidfile ENV.fetch('PIDFILE', 'tmp/pids/server.pid')

if ENV['RAILS_ENV'] == 'production'
  app_root = '/home/ubuntu/rails-demo'
  pidfile "#{app_root}/tmp/pids/puma.pid"
  state_path "#{app_root}/tmp/pids/puma.state"
  bind "unix://#{app_root}/tmp/sockets/puma.sock"
  activate_control_app "unix://#{app_root}/tmp/sockets/pumactl.sock"
  daemonize true
  workers 2
  threads 8, 16
  prune_bundler

  stdout_redirect "#{app_root}/log/puma_access.log", "#{app_root}/log/puma_error.log", true
end

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked web server processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
#
# workers ENV.fetch("WEB_CONCURRENCY") { 2 }

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory.
#
# preload_app!

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart

# ---------------------------------------------------------------------------- #
#                                 experimental                                 #
# ---------------------------------------------------------------------------- #
# 以下是Puma5实验性选项, 旨在增加速度, 如果出现性能问题, 请及时注释掉
# Lower latency, better throughput
wait_for_less_busy_worker 0.001

# Better memory usage
nakayoshi_fork
fork_worker
