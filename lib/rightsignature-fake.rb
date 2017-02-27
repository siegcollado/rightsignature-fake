require 'uri'
require 'webmock'
require 'rightsignature-fake/version'
require 'rightsignature-fake/configuration'
require 'rightsignature-fake/webhook'
require 'rightsignature-fake/server'

include WebMock::API
WebMock.enable!
WebMock.disable_net_connect!(allow_localhost: true)

module RightSignatureFake
  extend Configuration

  class << self
    attr_reader :request_template

    attr_accessor :redirect_location

    def stub_right_signature
      right_signature_server = RightSignatureFake::Server.boot
      stub_request(:any, /rightsignature.com/).to_rack(RightSignatureFake::Server)
      right_signature_url = "http://#{right_signature_server.host}:#{right_signature_server.port}"
      RightSignature::Connection.any_instance.stubs(:site).returns(right_signature_url)
    end

    def reset!
      @request_template = nil
      @redirect_location = nil
      @webhook_server = nil
    end

    def request_template=(value)
      @request_template ||= Hash.from_xml(value).fetch('template', {})
    end

    def guid
      @request_template.fetch('guid', '')
    end

    def callback_location
      @request_template.fetch('callback_location', '')
    end

    def webhook_server
      @webhook_server ||= RightSignatureFake::Webhook.new(callback_location)
    end
  end
end
