require 'bundler/setup'
require 'sinatra'
require 'mongo_mapper'
require 'haml'

MongoMapper.database = 'mongolog'

class Project 
  include MongoMapper::Document

  key :title, String
  key :amount, Integer
  key :date_funded, Date
  key :url, String
  key :status, String

  timestamps!
end

class Numeric
	def pretty_amount(cur='$', opts={})
    if opts[:cut_trailing_decimals]
      str = (self.abs/100.0).to_i.to_s
    else
      str = sprintf("%.2f", (self.abs/100.0))
    end

    "#{self < 0 ? '-' : ''}#{cur ? cur : ''}#{str.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")}"
  end
end

class App < Sinatra::Base
  get '/' do
  	@projects = Project.where(:status => {'$exists' => false}, :amount.gt => 0).sort(:amount.desc).all
    @contacted_projects = Project.where(:amount.gt => 0, :status => "contact").sort(:amount.desc).all
    haml :index
  end

  get '/:id/contact' do  
    n = Project.find(params[:id])
    n.status = "contact"
    n.save  
    redirect '/'  
  end 

    get '/:id/delete' do  
    n = Project.find(params[:id])
    n.status = "deleted"
    n.save  
    redirect '/'  
  end  
end