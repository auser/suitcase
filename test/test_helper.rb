require 'rubygems'
require 'test/unit'
require 'shoulda'
require "context"

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'suitcase/zipper'
require 'suitcase/unzipper'

class Test::Unit::TestCase
end
