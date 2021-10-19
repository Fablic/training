# frozen_string_literal: true

json.array! @labels, partial: 'labels/label', as: :label
