require 'mongo'

class DB

  def initialize(url, db, user, password)
    @url = url
    @db = db
    @user = user
    @password = password
  end

  def conn
    Mongo::Logger.level = Logger::FATAL
    Mongo::Client.new(
      @url, database: @db, user: @user, password: @password
    )
  end
end
