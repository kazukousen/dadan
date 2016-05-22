require 'zlib'
require 'fileutils'

module Dadan
  class Memo

    module WorkSpace
      Dadan = "#{Dir.home}/.dadan"
      Objects = "#{Dadan}/objects"
      Path = "#{Dadan}/worker.md"
    end

    def initialize(editor)
      @editor = editor
      if File.exists?(WorkSpace::Dadan)
        FileUtils.rm(WorkSpace::Path) if File.exists?(WorkSpace::Path)
      else
        FileUtils.mkdir_p(WorkSpace::Dadan)
      end
    end

    attr_reader :editor

    def edit
      system("#{@editor} #{WorkSpace::Path}")
    end

    def save
      time = Time.now.strftime("%Y%m%d%H%M%S")
      packed_body = Zlib::Deflate.deflate(File.read(WorkSpace::Path))
      FileUtils.mkdir_p(WorkSpace::Objects) unless File.exists?(WorkSpace::Objects)

      open("#{WorkSpace::Objects}/#{time}", 'w') do |file|
        file.write packed_body
      end

      time
    end

    def self.open_dayfile(day)
      statements = ""
      Dir.glob("#{Dir.home}/.dadan/objects/#{day}*").each do |file|
        statements << self.open_object(file[-14..-1])
        statements << "---\n"
      end
      puts statements
    end

    def self.open_file(time)
      puts self.open_object(time)
    end

    private
    def self.open_object(time)
      object_path = "#{WorkSpace::Objects}/#{time}"
      raise 'Invalid File at this time' unless File.exists?(object_path)
      Zlib::Inflate.inflate(File.read(object_path))
    end
  end
end
