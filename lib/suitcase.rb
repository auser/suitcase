$:.unshift(File.join(File.dirname(__FILE__), "suitcase"))

%w(zipper unzipper).each do |lib|
  require lib
end