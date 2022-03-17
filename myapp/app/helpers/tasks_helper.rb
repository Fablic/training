module TasksHelper
    def getLabelName(labelId)
        if labelId.present?
            Label.find(labelId).name
        else
            '-'
        end
    end

    def createLabelSelectOption(labels)
        selectOptions = {t(".not_choose_label") => ""}
        labels.each do |label|
            selectOptions[label.name] = label.id
        end
        return selectOptions
    end
end
