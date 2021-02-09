# coding: utf-8
require "spec_helper"

describe App do
  let(:app) { App.new }

  shared_examples_for 'raises 403' do
    it 'raises 403 Error' do
      expect(response.status).to eq 403
      expect(response.body).to match 'Error 403'
    end
  end

  shared_examples_for 'raises 404' do
    it 'raises 404 Error' do
      expect(response.status).to eq 404
      expect(response.body).to match 'Error 404'
    end
  end


  context 'GET /' do
    let(:response) { get '/', {}}
    it 'redirects to /de' do
      expect(response).to redirect_to '/de'
    end
  end

  context 'GET /de' do
    let(:response) { get '/de', {}}
    it 'renders german form' do
      expect(response).to match 'Ganzer Name'
    end
  end

  context 'GET /en' do
    let(:response) { get '/en', {}}
    it 'renders english form' do
      expect(response).to match 'Full name'
    end
  end

  describe 'POST /send' do
    include Mail::Matchers

    before(:each) do
      Mail::TestMailer.deliveries.clear
    end

    context 'giving an allowed domain' do
      let(:response) { post "/send", { name: 'Foo Name'}}
      pending { is_expected.to have_sent_email }
      it 'redirects back to form' do
        expect(response.location).to_not match '/send'
      end
    end
  end
end
