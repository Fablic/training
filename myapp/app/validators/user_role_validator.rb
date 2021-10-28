class UserRoleValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value == User.roles['owner']
    return if User.where(id: record.id).blank?
    return if User.find(record.id).role != User.roles['owner']
    return if User.where(role: User.roles['owner']).count > 1

    record.errors.add(attribute, :last_one)
  end
end
