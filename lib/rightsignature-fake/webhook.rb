require 'net/http'
require 'date'
require 'httparty'

module RightSignatureFake
  class Webhook
    module Statuses
      CREATED          = 'created'.freeze
      RECIPIENT_SIGNED = 'recipient_signed'.freeze
      SIGNED           = 'signed'.freeze
      VIEWED           = 'viewed'.freeze
    end

    CALLBACK_TYPE = 'Document'.freeze

    attr_accessor :callback_url

    def initialize(callback_url)
      @callback_url = callback_url
    end

    def trigger(status:, guid:, other_params: {})
      self.class.trigger(callback_url: @callback_url, status: status, guid: guid, other_params: other_params)
    end

    class << self
      def trigger(callback_url:, status:, guid:, other_params: {})
        Thread.new do
          HTTParty.get URI(callback_url),
                       query: { callback: build_callback_hash(status: status,
                                                              guid: guid,
                                                              other_params: other_params) }
        end
      end

      private

      def build_callback_hash(guid:, status:, other_params: {})
        { callback_type: CALLBACK_TYPE, redirect_token: nil, guid: guid, status: status,
          created_at: other_params.fetch(:created_at, Time.now - (3600 * 24)) }.tap do |result|
          if [Statuses::VIEWED, Statuses::RECIPIENT_SIGNED].include? status
            result[:recipient] = default_recipient_hash other_params.fetch(:recipient, {})
          end

          if status != Statuses::CREATED
            result[:signed_at] = other_params.fetch(:signed_at, Time.now)
          end
        end
      end

      def default_recipient_hash(params)
        { email: 'noemail@rightsignature.com', name: 'Some Name' }
          .merge(params)
          .keep_if { |key, _v| [:name, :email].include?(key) }
      end
    end
  end
end
