module TasksHelper
    def get_label_name(labelId)
        if labelId.present?
            Label.find(labelId).name
        else
            '-'
        end
    end

    def create_label_select_option(labels)
        selectOptions = {t(".not_choose_label") => ""}
        labels.each do |label|
            selectOptions[label.name] = label.id
        end
        return selectOptions
    end
end
