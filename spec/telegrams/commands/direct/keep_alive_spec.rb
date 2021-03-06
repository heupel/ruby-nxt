require './spec/helper'
require './lib/telegrams/commands/direct/keep_alive'

describe KeepAlive do
  describe "when constructing the object" do
    it "must not accept any parameters" do
      -> { KeepAlive.new false }.must_raise ArgumentError
    end

    it "must default to requiring a response since it is asking for one" do
      KeepAlive.new.require_response?.must_equal true
    end

    it "must have a command of 0x0D for getbatterylevel" do
      KeepAlive.new.command.must_equal 0x0D
    end
  end

  describe "as_bytes" do
    it "must have the command as the second byte" do
      command = KeepAlive.new
      command.as_bytes[1].must_equal command.command
    end
  end

end
