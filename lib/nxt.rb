def should_exclude_file(filename, current_directory)
  filename == File.join(current_directory, __FILE__) ||
  filename == File.join(current_directory, 'telegrams', 'commands', 'direct', 'output_state.rb')
end

current_directory = File.dirname(__FILE__)
files_to_require = Dir.glob(File.join(current_directory, '**/*.rb'))

files_to_require.each do |filename|
  require filename unless should_exclude_file(filename, current_directory)
end


class NXT
  attr_reader :device_path, :communication, :wait_for_reply

  def initialize(device_path, communication=nil)
    raise ArgumentError, "device_path must be non-nil" if device_path.nil?

    @wait_for_reply = true
    @device_path = device_path
    @communication = communication || BluetoothCommunication.new(device_path)
    @async = nil
  end

  def connect
    @communication.connect
    self
  end

  def disconnect
    @communication.disconnect
    self
  end

  def async
    @async = NXTAsync.new(@device_path, @communication) if @async.nil?
    @async
  end

  # Direct commands
  def stop_program
    send_message(StopProgram.new(wait_for_reply), StopProgramReply)
  end

  def start_program(program_name)
    send_message(StartProgram.new(program_name, wait_for_reply), StartProgramReply)
  end

  def get_current_program_name
    # always requires a reply, so no constructor argument to allow an override
    send_message(GetCurrentProgramName.new, GetCurrentProgramNameReply)
  end

  def stop_sound_playback
    send_message(StopSoundPlayback.new(wait_for_reply), StopSoundPlaybackReply)
  end

  def play_sound_file(sound_filename, loop_sound=false)
    send_message(PlaySoundFile.new(sound_filename, loop_sound, wait_for_reply), PlaySoundFileReply)
  end

  def play_tone(frequency_hz, duration_ms)
    send_message(PlayTone.new(frequency_hz, duration_ms, wait_for_reply), PlayToneReply)
  end

  def set_input_mode(input_port, sensor_type, sensor_mode)
    send_message(SetInputMode.new(input_port, sensor_type, sensor_mode, wait_for_reply), SetInputModeReply)
  end

  def set_output_state(output_state)
    send_message(SetOutputState.new(output_state, wait_for_reply),SetOutputStateReply)
  end

  def get_battery_level
    send_message(GetBatteryLevel.new, GetBatteryLevelReply)
  end

  def reset_motor_position
    send_message(ResetMotorPosition.new(wait_for_reply), ResetMotorPositionReply)
  end

  def keep_alive
    send_message(KeepAlive.new, KeepAliveReply)
  end

  private
  def yet_to_be_implemented_method
    raise NotImplementedError, "This method is not yet implemented"
  end

  public
  [:get_output_state, :get_input_values, :reset_input_scaled_value,
       :message_write, :message_read,
       :ls_get_status, :ls_write, :ls_read].each do |method|
         alias_method method, :yet_to_be_implemented_method
  end

  # System commands
  def get_device_info
    # always requires a reply, so no constructor argument to allow an override
    send_message(GetDeviceInfo.new, GetDeviceInfoReply)
  end

  # Lowest-level API
  def send_message(command, reply_type=nil)
    @communication.send_message(command, reply_type)
  end
end



class NXTAsync < NXT
  def initialize(device_path, communication=nil)
    super(device_path, communication)
    @wait_for_reply = false
  end

  def async
    self
  end
end
