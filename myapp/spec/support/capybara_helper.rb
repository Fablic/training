module CapybaraHelper
  def have_spec(value, **kw_args)
    have_selector("[data-spec='#{value}']", **kw_args)
  end

  def within_spec(value, **kw_args, &block)
    within("[data-spec='#{value}']", **kw_args, &block)
  end
end
