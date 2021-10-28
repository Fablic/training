module UsersHelper
  def translate_authority(authority)
    return t("activerecord.enum.user.authority.#{User.authoritys.invert[authority]}") if User.authoritys.value?(authority)

    raise "Unexpected priority `#{authority}` is set."
  end

end
