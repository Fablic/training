module LabelsHelper
  def custom_label(label)
    content_tag(:div, class: 'label', style: "--color: #{label.color}") do
      link_to(label.name, edit_label_path(I18n.locale, label), class: 'label__link')
    end
  end
end
