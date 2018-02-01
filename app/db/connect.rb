require 'mongo'

class DB

  def initialize(url)
    @url = url
    @db = 'admin'
    # @user = user
    # @password = password
  end

  def conn
    Mongo::Logger.level = Logger::FATAL
    Mongo::Client.new(
      @url, database: @db
      # @url, database: @db, user: @user, password: @password
    )
  end
end
