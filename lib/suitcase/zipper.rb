require 'rubygems'
require 'archive/tar/minitar'

module Suitcase
  class Zipper

    def self.items(default_dirs={})
      @items ||= default_dirs
    end
    
    def self.zip!(filepath)
      filepath = filepath.include?(".tar.gz") ? filepath : "#{filepath}.tar.gz"
      File.open(filepath,"w") do |tarfile|
        Archive::Tar::Minitar::Writer.open(tarfile) do |tar|
          items.each do |name, path|
            data = open(path).read
            tar.add_file_simple(name, :size=>data.size, :mode=>0644) { |f| f.write(data) }
          end
        end
      end
      filepath
    end
    
    def self.flush!
      @items = nil
    end

    def self.add(files_and_directories=[], namespace="")
      files_and_directories.each do |file|
        f = ::File.expand_path(file)        
        if ::File.file? f
          items.merge!(("#{namespace}/#{::File.basename(f)}").to_s => f)
        elsif ::File.directory? f
          Dir["#{f}/*"].each do |f|
            add(f, "#{namespace.empty? ? "" : "#{namespace}/"}#{::File.basename(::File.dirname(f))}")
          end
        end
      end
    end

    def self.gems(gem_list, gem_location)
      require 'rubygems/dependency_installer'
      ensure_location_exists gem_location

      cache_dir = "#{gem_location}/cache"
      ::FileUtils.mkdir_p cache_dir rescue nil unless File.exist? cache_dir

      gem_list.each do |g|
        di = Gem::DependencyInstaller.new
        spec, url = di.find_spec_by_name_and_version(g).first
        f = begin
          Gem::RemoteFetcher.fetcher.download spec, "http://gems.github.com", gem_location
        rescue Exception => e
          Gem::RemoteFetcher.fetcher.download spec, url, gem_location
        end
        add(f, "gems")
      end
    end

    def self.packages(package_list, package_location="#{Dir.pwd}/packages")
      ensure_location_exists package_location
      package_list.each do |package|
        f = "#{package_location}/#{package.split('/').last}"
        puts "downloading #{package} to #{f}"
        `curl -L #{package} > #{package_location}/#{package.split('/').last}`
        
        add(f, "packages")
      end
    end
    
    def self.ensure_location_exists(loc)
      ::FileUtils.mkdir_p loc unless ::File.directory? loc
    end

  end
end