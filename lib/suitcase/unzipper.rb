require 'rubygems'
require "zlib"
require 'archive/tar/minitar'

module Suitcase
  class UnZipper
    
    # TODO: Add a meaningful, portable unzip!
    def self.unzip!(filepath, to=Dir.pwd)
      # tgz = Zlib::GzipReader.new(File.open(filepath, 'rb'))      
      # Archive::Tar::Minitar.unpack( tgz, to )
    end
    
  end
end