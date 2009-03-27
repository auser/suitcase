require 'rubygems'
require "zlib"
require 'archive/tar/minitar'

module Suitcase
  class UnZipper
    
    def self.unzip!(filepath, to=Dir.pwd)
      p "hi: #{File.open(filepath, 'rb')}"
      Archive::Tar::Minitar::Reader.new( File.open(filepath, 'rb').read ) do |is|
        p "hi"
        is.each_entry do |entry|          
          p entry
        end
      end
    end
    
  end
end