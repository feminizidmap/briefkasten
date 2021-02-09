require "erb"
require 'sanitize'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/r18n'
require 'mail'

require './helpers/application_helper'

class Forbidden < StandardError
  def http_status; 403 end
end

class NotFound < StandardError
  def http_status; 404 end
end

class App < Sinatra::Base
  register Sinatra::R18n
  set :root, __dir__
  helpers ApplicationHelper

  get '/' do
    redirect to '/de'
  end

  get '/:locale' do
    erb :index
  end

  post '/send' do
    #puts params
    name = Sanitize.fragment(params[:name], Sanitize::Config::RELAXED)

    email_body = erb :mailer, locals: {name: name}
    mail = Mail.new do
      from    "#{ENV['EMAIL_FROM']}"
      to      "#{ENV['EMAIL_TO']}"
      subject "[#{ENV['APP_NAME']}] You got mail!"
      body    email_body
    end
    mail.delivery_method :sendmail
    mail.deliver!

    redirect back
  end

  error 403 do
    'Error 403 Forbidden'
  end

  error 404 do
    'Error 404 Not Found'
  end
end
