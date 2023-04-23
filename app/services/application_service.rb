class ApplicationService
  def self.call(...)
    new(...).call
  end

  def serialize(object, options: {})
    ActiveModelSerializers::SerializableResource.new(object, **options).serializable_hash
  end
end
