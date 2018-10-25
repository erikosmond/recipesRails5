class AccessService
  def self.create_access!(user_id, subject, status = :private)
    if subject.respond_to?(:access)
      Access.create!(
        user_id: user_id,
        accessible: subject,
        status: status
      )
    else
      raise ArgumentError,
            "Cannot create Access record for class #{subject.class.name}"
    end
  end
end
