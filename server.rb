require 'sinatra'
require 'pry'
require 'csv'
require_relative 'lib/article.rb'
require 'net/http'

previous_params = {}
error = false
error_message = "You have made an error in submission!"

get "/articles" do
  articles = []
  CSV.foreach('articles.csv', headers: true, header_converters: :symbol) do |row|
    row_hash = row.to_hash
    article = Article.new(row_hash[:title], row_hash[:url], row_hash[:description])
    Article.save(article)
    articles << article
  end
  @articles = articles
  erb :articles
end

get "/articles/new" do
  @previous_title = previous_params[:title]
  @previous_url = previous_params[:url]
  @previous_description = previous_params[:description]
  @error = error_message if error
  error = false
  previous_params = {}
  erb :articles_new
end

post "/articles/new" do
  article_exists = Article.all.any? { |article| article.url == params[:url] }
  empty_input = params[:title] == "" || params[:url] == "" || params[:description] == ""
  
  if empty_input || params[:description].length < 20 || article_exists
    previous_params = params
    error = true
    redirect "/articles/new"
  else
    CSV.open('articles.csv', "a") do |csv|
      csv << [params[:title], params[:url], params[:description]]
    end
    redirect "/articles"
  end
end
