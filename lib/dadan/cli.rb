# coding: utf-8
require 'dadan'
require 'thor'

module Dadan
  class CLI < Thor
    module Worker
      Editor = 'vi'
      Path = "#{Dir.home}/.dadan/worker.md"
    end
    default_command :first_run

    desc 'hello NAME', 'say hello to NAME'
    def hello(name)
      puts 'hello ' << name
    end

    desc 'run', 'default new file'
    def first_run
      memo = Memo.new(Worker::Editor)
      memo.edit
      time = memo.save
      puts "Memorized at #{time}"
    end

    desc 'worker', 'workspace'
    def worker
      dir = "#{Dir.home}/.dadan/"
      FileUtils.mkdir_p(dir) unless File.exists?(dir)

      worker_path = "#{dir}/worker.md"

      FileUtils.rm(worker_path) if File.exists?(worker_path)
    end

    desc 'edior', 'vim output'
    def edit
      system("#{Worker::Editor} #{Worker::Path}")
    end

    desc 'save', 'file save'
    def save
      Memo.save_file(Worker::Path)
    end

    desc "today's file", "today's file open"
    def today
      day = Time.now.strftime("%Y%m%d")
      Memo.open_dayfile(day)
    end

    desc "yesterday's file", "yesterday's file open"
    def yesterday
      day = Time.now.yesterday.strftime("%Y%m%d")
      Memo.open_dayfile(day)
    end

    desc "day's file", "day's file open"
    def day(daytime)
      if daytime.length == 4
        year = Time.now.strftime("%Y")
        daytime = "#{year}#{daytime}"
      end
      Memo.open_dayfile(daytime)
    end
  end
end
