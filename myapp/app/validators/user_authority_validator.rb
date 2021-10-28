class UserAuthorityValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value == User.authoritys['owner']
    return if User.where(id: record.id).blank?
    return if User.find(record.id).authority != User.authoritys['owner']
    return if User.where(authority: User.authoritys['owner']).count > 1

    record.errors.add(attribute, :last_one)
  end
end
