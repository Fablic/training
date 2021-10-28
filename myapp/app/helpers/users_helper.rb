module UsersHelper
  def translate_authority(authority)
    if User.authoritys.value?(authority)
      return t("activerecord.enum.user.authority.#{User.authoritys.invert[authority]}")
    end

    raise "Unexpected priority `#{authority}` is set."
  end
end
