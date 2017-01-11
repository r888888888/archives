#!/usr/bin/env ruby

require "dotenv"
Dotenv.load

require 'aws-sdk'

MAX_BACKUPS = 20

Aws.config.update(
  region: ENV["AMAZON_SQS_REGION"],
  credentials: Aws::Credentials.new(
    ENV["AMAZON_KEY"],
    ENV["AMAZON_SECRET"]
  )
)

S3 = Aws::S3::Client.new

## upload postgresql
bucket = "danbooru-archive-backup"

current_backups = S3.list_objects(bucket: bucket).contents.map {|x| x.key}.select {|x| x =~ /^db-/}.sort.reverse

if current_backups.size > MAX_BACKUPS
  current_backups[MAX_BACKUPS..-1].each do |old_backup|
    S3.delete_object(bucket: bucket, key: old_backup)
    puts "Deleted old backup #{old_backup}"
  end
end

backup = Dir["/home/archiver/pg_archive_backups/archive_production-*.dump"].sort.last
data = File.open(backup, "rb")
filename = data.mtime.strftime("archive_production-%Y-%m-%d-%H-%M")
tries = 0

begin
  S3.put_object(bucket: bucket, key: filename, body: data, :acl => "private")
rescue Errno::EPIPE
  tries += 1
  if tries > 3
    raise
  else
    retry
  end
end

puts "Uploaded #{backup} as #{filename}"
