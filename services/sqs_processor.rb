#!/usr/bin/env ruby

$:.unshift(File.expand_path("../../models", __FILE__))

require "dotenv"
Dotenv.load ".env", "/run/secrets/archives_env"

require "logger"
require "aws-sdk"
require "optparse"
require "pool_version"
require "post_version"

unless ENV["RUN"]
  #Process.daemon(nil, true)
end

$running = true
$options = {
  pidfile: "/var/run/archives/sqs_processor.pid",
  logfile: "/var/log/archives/sqs_processor.log"
}

OptionParser.new do |opts|
  opts.on("--pidfile=PIDFILE") do |pidfile|
    $options[:pidfile] = pidfile
  end

  opts.on("--logfile=LOGFILE") do |logfile|
    $options[:logfile] = logfile
  end
end.parse!

LOGFILE = $options[:logfile] == "stdout" ? STDOUT : File.open($options[:logfile], "a")
LOGFILE.sync = true
LOGGER = Logger.new(LOGFILE, 0)
Aws.config.update(
  region: ENV["AMAZON_SQS_REGION"],
  credentials: Aws::Credentials.new(
    ENV["AMAZON_KEY"],
    ENV["AMAZON_SECRET"]
  )
)
SQS = Aws::SQS::Client.new
QUEUE = Aws::SQS::QueuePoller.new(ENV["SQS_ARCHIVES_URL"], client: SQS)

unless ENV["RUN"]
  File.open($options[:pidfile], "w") do |f|
    f.write(Process.pid)
  end
end

Signal.trap("TERM") do
  $running = false
end

def process_queue(poller, logger)
  logger.info "Starting"
  
  poller.before_request do
    unless $running
      throw :stop_polling
    end
  end

  while $running
    begin
      poller.poll do |msg|
        command, json = msg.body.split(/\n/)
        json = JSON.parse(json)

        case command
        when "add pool version"
          logger.info("add pool version json=#{json.inspect}")
          PoolVersion.create_from_json(json)

        when "add post version"
          logger.info("add post version json=#{json.inspect}")
          PostVersion.create_from_json(json)

        else
          logger.info("unknown command: #{command}")
        end
      end
      
    rescue Interrupt
      exit(0)

    rescue Exception => e
      logger.error("#{e.class} thrown")
      logger.error(e.message)
      logger.error(e.backtrace.join("\n"))

      if ENV["RUN"]
        exit(1)
      end

      60.times do
        sleep 1
        exit(1) unless $running
      end

      retry
    end
  end
end

process_queue(QUEUE, LOGGER)