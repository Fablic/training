module AdminHelper
  def admin_screen?
    request.fullpath.split(File::SEPARATOR)[1] === "admin"
  end
end