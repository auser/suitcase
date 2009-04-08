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
    
    def self.build_dir!(dirpath)
      ::FileUtils.mkdir_p dirpath unless ::File.directory? dirpath
      items.each do |name, path|
        end_path = "#{dirpath}/#{name}"
        unless name == ::File.basename(name)
          ::FileUtils.mkdir_p ::File.dirname(end_path) unless ::File.directory? ::File.dirname(end_path)
        end
        ::FileUtils.cp path, end_path
      end
      dirpath
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
      gem_list = [gem_list] unless gem_list.is_a?(Array)
      ensure_location_exists gem_location

      cache_dir = "#{gem_location}/cache"
      ::FileUtils.mkdir_p cache_dir rescue nil unless File.exist? cache_dir

      locally_installed_gems = Gem::SourceIndex.from_installed_gems.map {|n,s| s.name }
      
      locally_installable_gems = gem_list & locally_installed_gems
      remotely_installable = gem_list - locally_installable_gems
      
      # First, add the locally installed gems
      locally_installable_gems.each do |spec|
        spec = Gem::SourceIndex.from_installed_gems.find_name(spec).last#.sort_by {|a,b| a.version <=> b.version }.last                
        f = Dir[File.join(Gem.dir, 'cache', "#{spec.full_name}.gem")].first
        add(f, "gems")
      end
      
      remotely_installable.each do |g|
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
        unless ::File.file? f
          puts "downloading #{package} to #{f}"
          `curl -L #{package} > #{package_location}/#{package.split('/').last}`
        end
        
        add(f, "packages")
      end
    end
    
    def self.ensure_location_exists(loc)
      ::FileUtils.mkdir_p loc unless ::File.directory? loc
    end

  end
end