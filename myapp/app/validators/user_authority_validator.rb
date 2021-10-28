class UserAuthorityValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless User.where(id: record.id).present?
    if User.find(record.id).authority == User.authoritys['owner'] && 1 == User.where(authority: User.authoritys['owner']).count && value != User.authoritys['owner']
      record.errors.add(attribute, :last_one)
    end
  end
end
