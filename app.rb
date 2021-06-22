require 'erb'
require 'logger'
require 'mail'
require 'sanitize'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/cors'
require 'sinatra/r18n'

require './helpers/application_helper'

class Forbidden < StandardError
  def http_status; 403 end
end

class NotFound < StandardError
  def http_status; 404 end
end

class App < Sinatra::Base
  register Sinatra::R18n
  register Sinatra::Cors

  set :root, __dir__
  set :allow_origin, "#{ENV['ALLOW_LIST']}"
  set :allow_methods, "GET,HEAD,POST"
  set :allow_headers, "content-type"

  helpers ApplicationHelper
  log = Logger.new('logs/log.txt', 'monthly')

  get '/' do
    redirect to '/de'
  end

  get '/:locale' do
    erb :index, locals: { language: params[:locale] }
  end

  post '/send' do
    log.info "Request hit /send"

    clean_params = {}
    params.each do |key, value|
      clean_params[key] = Sanitize.fragment(value, Sanitize::Config::RESTRICTED)
    end

    Thread.abort_on_exception = true
    Thread.new  {
       log.info "Starting thread to write email"
       email_body = erb :mailer, locals: { fields: clean_params }
       mail = Mail.new do
         from    "#{ENV['EMAIL_FROM']}"
         to      "#{ENV['EMAIL_TO']}"
         subject "[#{ENV['APP_NAME']}] A case was reported!"
         body     email_body
       end
       mail.delivery_method :sendmail
      # use this but also run `bundle exec mailcatcher` in another terminal window
      #mail.delivery_method :smtp, address: "localhost", port: 1025
      mail.deliver!
      log.info "Done emailing"
    }

    erb :byebye

#Or just write it here directly? "Case Successfully Reported!" ?

  end

  error 403 do
    'Error 403 Forbidden'
  end

  error 404 do
    'Error 404 Not Found'
  end
end
