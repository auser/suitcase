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
    # UNCOMMENT THESE TO LIVE-TEST THE USAGE
    # should "be able to add gems to the suitcase" do
    #   Suitcase::Zipper.gems("archive-tar-minitar", Dir.pwd)
    #   assert_equal Suitcase::Zipper.items["gems/archive-tar-minitar-0.5.2.gem"], ::File.expand_path("cache/archive-tar-minitar-0.5.2.gem")
    # end
    # should "be able to add packages to the suitcase" do
    #   Suitcase::Zipper.packages("ftp://ftp.ruby-lang.org/pub/ruby/stable-snapshot.tar.gz", "#{Dir.pwd}/packages")
    #   assert_equal Suitcase::Zipper.items["packages/stable-snapshot.tar.gz"], ::File.expand_path("packages/stable-snapshot.tar.gz")
    # end
    should "zip the packages into a tarball without the extension" do
      filepath = "#{::File.dirname(__FILE__)}/package"
      Suitcase::Zipper.add("test_dir")
      Suitcase::Zipper.add("test_helper.rb")
      Suitcase::Zipper.zip!(filepath)
      assert ::File.file?("#{filepath}.tgz")
    end
    should "zip the packages into a tarball with the extension" do
      filepath = "#{::File.dirname(__FILE__)}/package.tgz"
      Suitcase::Zipper.add("test_dir")
      Suitcase::Zipper.add("test_helper.rb")
      Suitcase::Zipper.zip!(filepath)
      assert ::File.file?("#{filepath}")
    end
    should "be able to unpack the packages" do
      filepath = "#{::File.dirname(__FILE__)}/package.tgz"
      Suitcase::Zipper.add("test_dir")
      Suitcase::Zipper.add("test_helper.rb")
      Suitcase::Zipper.zip!(filepath)
      
      Suitcase::UnZipper.unzip!(filepath, "#{Dir.pwd}")
      assert ::File.directory?("#{::File.dirname(filepath)}")
    end
    after do
      ::FileUtils.rm_rf "#{Dir.pwd}/packages"
      ::FileUtils.rm_rf "#{Dir.pwd}/cache"
      ::FileUtils.rm_rf "#{Dir.pwd}/package.tgz"
    end
  end
end
