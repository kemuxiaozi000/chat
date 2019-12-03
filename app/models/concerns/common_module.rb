module CommonModule
  def make_uuid
    SecureRandom.hex(10)
  end
end
