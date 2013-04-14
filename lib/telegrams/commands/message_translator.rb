module MessageTranslator
  FILENAME_MAX_LENGTH = 20 # 15.3 + null terminator

  def string_as_bytes(string, max_length=FILENAME_MAX_LENGTH)
    # pad out to max length with null characters and then
    # convert all to ASCIIZ (null-terminated ascii string)
    string.ljust(max_length, "\0").unpack('C*')
  end

  def string_from_bytes(bytes)
    # convert from ASCIIZ (null-terminated ascii), removing all the 
    # trailing null characters
    bytes.pack("C*").strip
  end

  def boolean_as_bytes(boolean)
    boolean ? [0xff] : [0x00]
  end

  def boolean_from_bytes(bytes)
    bytes == [0x00] ? false : true
  end

end
