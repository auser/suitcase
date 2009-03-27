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
      Suitcase::Zipper.add("test_helper.rb")
      assert_equal Suitcase::Zipper.items.size, 1
    end
    should "be able to add directories to the suitcase" do
      Suitcase::Zipper.add("test_dir")
      assert_equal Suitcase::Zipper.items.size, 2
      assert_equal Suitcase::Zipper.items["test_dir/box.rb"], ::File.expand_path("test_dir/box.rb")
    end
    should "be able to add gems to the suitcase" do
      Suitcase::Zipper.gems("archive-tar-minitar", Dir.pwd)
      assert_equal Suitcase::Zipper.items["gems/archive-tar-minitar-0.5.2.gem"], ::File.expand_path("cache/archive-tar-minitar-0.5.2.gem")
    end
    should "be able to add packages to the suitcase" do
      Suitcase::Zipper.packages("ftp://ftp.ruby-lang.org/pub/ruby/stable-snapshot.tar.gz", "#{Dir.pwd}/packages")
      assert_equal Suitcase::Zipper.items["packages/stable-snapshot.tar.gz"], ::File.expand_path("packages/stable-snapshot.tar.gz")
    end
    after do
      ::FileUtils.rm_rf "#{Dir.pwd}/packages"
      ::FileUtils.rm_rf "#{Dir.pwd}/cache"
    end
  end
end
