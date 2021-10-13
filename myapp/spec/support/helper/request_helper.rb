module RequestHelpers
  def json
    JSON.parse(response.body)
  end
end
