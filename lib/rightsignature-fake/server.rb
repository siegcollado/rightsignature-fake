require 'capybara'
require 'capybara/server'
require 'sinatra/base'

module RightSignatureFake
  class Server < Sinatra::Base
    def self.boot
      instance = new
      Capybara::Server.new(instance).tap(&:boot)
    end

    disable :protection

    post '/api/templates/:guid/prepackage.xml' do |guid|
      content_type :xml
      template_for(guid)
    end

    post '/api/templates.xml' do
      content_type :xml
      RightSignatureFake.request_template = request.body

      RightSignatureFake.webhook_server.trigger status: RightSignatureFake::Webhook::Statuses::CREATED,
                                                guid: RightSignatureFake.guid

      '<document><status>sent</status><guid>hello123</guid></document>'
    end

    get '/api/documents/hello123/signer_links.xml' do
      RightSignatureFake.redirect_location = params['redirect_location']

      <<-xml
        <?xml version="1.0" encoding="UTF-8"?>
        <document>
          <signer-links>
            <signer-link>
              <name>Tax Signer</name>
              <role>signer_A</role>
              <signer-token>46f022bb3e4b429f8f7c79a2f0b2d0c3</signer-token>
            </signer-link>
          </signer-links>
        </document>
      xml
    end

    get '/signatures/embedded' do
      '<form action="/submit_to_callback", method="post">' \
      '<input type="submit"/>' \
      '</form>'
    end

    post '/submit_to_callback' do
      RightSignatureFake.webhook_server.trigger status: RightSignatureFake::Webhook::Statuses::SIGNED,
                                                guid: @guid

      @redirect_location = RightSignatureFake.redirect_location
      erb :submit_to_callback
    end

    private

    # TODO: Do we need to generate this?
    def document_guid
      'hello123'
    end

    def template_for(guid)
      file_path = File.join(RightSignatureFake.template_path, "#{guid}.xml")
      File.open(file_path, 'rb').read
    rescue Errno::ENOENT
      file_path = File.join(RightSignatureFake::DEFAULT_TEMPLATE_PATH, 'default_template.xml')
      File.open(file_path, 'rb').read
    end
  end
end
