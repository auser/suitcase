require 'rubygems'

module Suitcase
  class Zipper

    def self.items(default_dirs={})
      @items ||= default_dirs
    end
    
    def self.zip!(filepath)
      require 'archive/tar/minitar'
      filepath = filepath.include?(".tar.gz") ? filepath : "#{filepath}.tar.gz"
      File.open(filepath,"w") do |tarfile|
        Archive::Tar::Minitar::Writer.open(tarfile) do |tar|
          items.each do |name, path|
            if name == :string              
              ::File.open("#{dirpath}/#{path[:namespace]}/#{path[:name]}", "w+") do |tf|
                tf << path[:content]
              end
            else
              data = open(path).read
              tar.add_file_simple(name, :size=>data.size, :mode=>0644) { |f| f.write(data) }
            end
          end
        end
      end
      filepath
    end
    
    def self.build_dir!(dirpath)
      ::FileUtils.mkdir_p dirpath unless ::File.directory? dirpath
      items.each do |name, path|
        if name.to_s =~ /string/
          fpath = "#{dirpath}/#{path[:namespace]}/#{path[:name]}"
          ensure_location_exists(::File.dirname(fpath))
          ::File.open(fpath, "w+") do |tf|
            tf << path[:content]
          end
        else          
          end_path = "#{dirpath}/#{name}"
          ::FileUtils.mkdir_p ::File.dirname(end_path) unless ::File.directory? ::File.dirname(end_path) unless name == ::File.basename(name)          
          ::FileUtils.cp path, end_path
        end
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
    
    # TODO: MOVE
    def self.gems(gem_list, o={})
      require 'rubygems/dependency_installer'
      gem_list = [gem_list] unless gem_list.is_a?(Array)
      
      gem_list.each do |g|
        add find_gem(g, o), "gems"
      end
    end
    
    # Find the gem named named
    # First, search in the :search_paths passed in via the options
    # If it's not found there, then search in the locally installed gems
    # and finally search online if the gem isn't available
    def self.find_gem(named, o={})
      require 'rubygems/dependency_installer'

      # Look for the gem in a path passed
      found_path = search_path_for_gem_in_paths(named, o[:search_paths]) if o[:search_paths]
      return found_path if found_path
      
      found_path = find_gem_in_locally_installed_gems(named)
      return found_path if found_path
      
      gem_location = o[:temp_path] || "/tmp/gems"
      ensure_location_exists(gem_location)
      
      found_path = find_gem_remotely_by_name_and_download_to(named, gem_location)
      return found_path if found_path        
      nil
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
    
    def self.add_content_as(content="", filename="", namespace="files")
      items.merge!({"string_#{filename}_#{namespace}".to_sym => {:name => ::File.basename(filename), :content => content, :namespace => namespace}})
    end
    
    def self.reset!
      @items = nil
    end
    
    private
    # Search for the gem in a given path
    def self.search_path_for_gem_in_paths(named, dirs)
      fi = dirs.map do |d|
        q = Dir["#{d}/*"].entries.detect {|fi|fi =~ /#{named}/}
        q ? q : nil
      end.compact.first
    end
    
    # Search in the locally installed gems
    def self.find_gem_in_locally_installed_gems(named)
      locally_installed_gems_list = locally_installed_gems.map {|n,s| s.name }
      
      locally_installed_gems_list.detect do |g|
        if g == named
          spec = locally_installed_gems.find_name(g).last
          if f = Dir[File.join(Gem.dir, 'cache', "#{spec.full_name}.gem")].first
            return f
          end
        end
      end
      nil
    end
    
    def self.locally_installed_gems
      @locally_installed_gems ||= Gem::SourceIndex.from_installed_gems
    end
    
    # Find the gem from online, first trying gems.github.com
    # and then from rubyforge
    def self.find_gem_remotely_by_name_and_download_to(named, to, o={})
      # Look for the gems from remote
      di = Gem::DependencyInstaller.new
      spec, url = di.find_spec_by_name_and_version(named).first
      f = begin
        Gem::RemoteFetcher.fetcher.download spec, "http://gems.github.com", to
      rescue Exception => e
        Gem::RemoteFetcher.fetcher.download spec, url, to
      end        
      return f if f
      nil
    end
    

  end
end