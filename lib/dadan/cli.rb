# coding: utf-8
require 'dadan'
require 'thor'

module Dadan
  class CLI < Thor
    module Worker
      Path = "#{Dir.home}/.dadan/worker.md"
    end
    default_command :first_run

    desc 'hello NAME', 'say hello to NAME'
    def hello(name)
      puts 'hello ' << name
    end

    desc 'run', 'default new file'
    def first_run
      worker
      edit
      save
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
      system("vi #{Worker::Path}")
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
  end
end
