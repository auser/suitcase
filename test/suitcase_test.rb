require 'test_helper'

class DependenciesTest < Test::Unit::TestCase
  context "basics" do
    should "should have a method called dedependencies" do
      assert Suitcase::Zipper.respond_to?(:items)
    end
    should "should have a package(file) method" do
      assert Suitcase::Zipper.respond_to?(:add)
    end
  end
  context "adding gems" do
    before do
      Suitcase::Zipper.flush!
    end
    should "should have no gems before any are added" do
      assert_equal Suitcase::Zipper.items.size, 0
      assert_equal Suitcase::Zipper.items.class, Hash
    end
    should "be able to add files to the suitcase" do
      Suitcase::Zipper.add("#{::File.dirname(__FILE__)}/test_helper.rb")
      assert_equal Suitcase::Zipper.items.size, 1
    end
    should "be able to add directories to the suitcase" do
      Suitcase::Zipper.add("#{::File.dirname(__FILE__)}/test_dir")
      assert_equal Suitcase::Zipper.items.size, 2
      assert Suitcase::Zipper.items["test_dir/box.rb"] =~ /test_dir\/box\.rb/
    end
    should "be able to add directories into namespaces" do
      Suitcase::Zipper.add("#{::File.dirname(__FILE__)}/test_dir", "box")
      assert Suitcase::Zipper.items["box/test_dir/box.rb"] =~ /test_dir\/box\.rb/
    end
    # UNCOMMENT THESE TO LIVE-TEST THE USAGE
    should "be able to add gems to the suitcase" do
      Suitcase::Zipper.gems("rake", Dir.pwd)
      Suitcase::Zipper.build_dir! "#{Dir.pwd}/cache"
      assert ::File.file?(::File.expand_path("#{Dir.pwd}/cache/gems/rake-0.8.4.gem"))
    end
    should "find the gem online if it is not locally installed" do
      Suitcase::Zipper.gems("aaronp-meow", Dir.pwd)
      assert ::File.file?(::File.expand_path("#{Dir.pwd}/cache/aaronp-meow-1.1.0.gem"))
    end
    # should "be able to add packages to the suitcase" do
    #   Suitcase::Zipper.packages("ftp://ftp.ruby-lang.org/pub/ruby/stable-snapshot.tar.gz", "#{Dir.pwd}/packages")
    #   assert_equal Suitcase::Zipper.items["packages/stable-snapshot.tar.gz"], ::File.expand_path("packages/stable-snapshot.tar.gz")
    # end
    should "zip the packages into a tarball without the extension" do
      filepath = "#{::File.dirname(__FILE__)}/package"
      Suitcase::Zipper.add("test_dir")
      Suitcase::Zipper.add("test_helper.rb")
      Suitcase::Zipper.zip!(filepath)
      assert ::File.file?("#{filepath}.tar.gz")
    end
    should "zip the packages into a tarball with the extension" do
      filepath = "#{::File.dirname(__FILE__)}/package.tar.gz"
      Suitcase::Zipper.add("test_dir")
      Suitcase::Zipper.add("test_helper.rb")
      Suitcase::Zipper.zip!(filepath)
      assert ::File.file?("#{filepath}")
    end
    should "be able to unpack the packages" do
      filepath = "#{::File.dirname(__FILE__)}/package.tar.gz"
      Suitcase::Zipper.add("test_dir")
      Suitcase::Zipper.add("test_helper.rb")
      Suitcase::Zipper.zip!(filepath)
      
      Suitcase::UnZipper.unzip!(filepath, "#{Dir.pwd}")
      assert ::File.directory?("#{::File.dirname(filepath)}")
    end
    should "have a method called build_dir!" do
      assert Suitcase::Zipper.respond_to?(:build_dir!)
    end
    should "call build_dir" do
      Suitcase::Zipper.add("test_dir")
      Suitcase::Zipper.add("test_helper.rb")
      
      pth = Suitcase::Zipper.build_dir!("/tmp/poolparty/deps")
      
      assert ::File.directory?("/tmp/poolparty/deps")
      assert_equal pth, "/tmp/poolparty/deps"
      ::FileUtils.rm_rf "/tmp/poolparty/deps"
    end
    after do
      ::FileUtils.rm_rf "#{Dir.pwd}/packages"
      ::FileUtils.rm_rf "#{Dir.pwd}/cache"
      ::FileUtils.rm_rf "#{Dir.pwd}/package.tar.gz"
    end
  end
end
