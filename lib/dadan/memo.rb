require 'digest/sha1'
require 'zlib'
require 'fileutils'

module Dadan
  class Memo
    module ObjectType
      File = 'file'
    end

    def self.save_file(worker_path)
      time = Time.now.strftime("%Y%m%d%H%M%S")
      self.save_object(ObjectType::File, worker_path, time)
    end

    def self.open_dayfile(day)
      Dir.glob("#{Dir.home}/.dadan/objects/#{day}*").each do |file|
        puts self.open_object(ObjectType::File, file[-14..-1])
      end
    end

    def self.open_file(time)
      self.open_object(ObjectType::File, time)
    end

    private
    def self.save_object(object_type, src_path, time)
      packed_body = Zlib::Deflate.deflate(File.read(src_path))

      object_dir = "#{Dir.home}/.dadan/objects"
      FileUtils.mkdir_p(object_dir) unless File.exists?(object_dir)

      open("#{object_dir}/#{time}", 'w') do |file|
        file.write packed_body
      end

      time
    end

    def self.open_object(object_type, time)
      object_path = "#{Dir.home}/.dadan/objects/#{time}"
      raise 'Invalid File at this time' unless File.exists?(object_path)
      Zlib::Inflate.inflate(File.read(object_path))
    end
  end
end
