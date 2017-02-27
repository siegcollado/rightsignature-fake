module RightSignatureFake
  DEFAULT_TEMPLATE_PATH = File.join(File.dirname(__FILE__), 'templates').freeze

  module Configuration
    attr_writer :template_path

    def template_path
      @template_path || RightSignatureFake::DEFAULT_TEMPLATE_PATH
    end

    def configure
      yield self
    end
  end
end
