require 'net/http'

class Article
  attr_reader :title, :url, :description
  @@all_articles = []

  def initialize(title, url, description)
    @title = title
    # new_url = validate_url(url)
    # @url = new_url
    @url = url
    @description = description
  end

  def self.all
    @@all_articles
  end

  def self.save(article)
    @@all_articles << article
  end





  # def validate_url(url)
  #   uri = URI.parse(url)
  #   output = uri.scheme ? url : "http://#{uri.path}"
  # end
end
