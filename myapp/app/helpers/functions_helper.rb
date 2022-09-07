module FunctionsHelper
  def check_system_started
    if Function.is_stopped(Function::FUNC_ID_SYSTEM)
      render(
        file: Rails.public_path.join("503.html"),
        content_type: "text/html",
        layout: false,
        status: :service_unavailable,
      )
    end
  end
end
