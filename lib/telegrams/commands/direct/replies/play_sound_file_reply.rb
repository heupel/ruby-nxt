require_relative '../../direct_command_reply'

class PlaySoundFileReply < DirectCommandReply
  def initialize(bytes)
    super(bytes)
  end

  # override
  def validate_bytes(bytes)
    super(bytes)
    raise ArgumentError, "must be a reply for a PlaySoundFile command" unless bytes[1] == 0x02
  end
end
