require 'mongo'

class DB

  def initialize(url)
    @url = url
    # @user = user
    # @password = password
  end

  def conn
    Mongo::Logger.level = Logger::FATAL
    Mongo::Client.new(
      @url
    )
  end
end
