module UsersHelper
  def translate_role(role)
    return t("activerecord.enum.user.role.#{role}") if User.roles[role].present?

    raise "Unexpected priority `#{role}` is set."
  end
end
