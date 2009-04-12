require 'rubygems'

module Suitcase
  class UnZipper
    
    # TODO: Add a meaningful, portable unzip!
    def self.unzip!(filepath, to=Dir.pwd)
      require "zlib"
      require 'archive/tar/minitar'
      # tgz = Zlib::GzipReader.new(File.open(filepath, 'rb'))      
      # Archive::Tar::Minitar.unpack( tgz, to )
    end
    
  end
end