require 'rightsignature-fake/support/base'

RSpec.configure do |c|
  c.include RightSignatureFake::Support::TestHelpers

  c.around right_signature: true do |example|
    RightSignatureFake.stub_right_signature
    example.run
    RightSignatureFake.reset!
  end
end
