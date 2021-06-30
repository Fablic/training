module IdGenerator
  def self.included(klass)
    klass.before_create :fill_id
  end

  def fill_id
    self.id = loop do
      uuid = SecureRandom.uuid
      break uuid unless self.class.exists?(id: uuid)
    end
  end
end
