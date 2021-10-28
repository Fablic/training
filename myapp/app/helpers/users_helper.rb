module UsersHelper
  def translate_role(role)
    return t("activerecord.enum.user.role.#{User.roles.invert[role]}") if User.roles.value?(role)

    raise "Unexpected priority `#{role}` is set."
  end
end
