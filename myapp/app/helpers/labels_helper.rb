module LabelsHelper
  def custom_label(label, link:)
    content_tag(:div, class: 'label', style: "--color: #{label.color}") do
      link_to(label.name, link, class: 'label__link')
    end
  end
end
