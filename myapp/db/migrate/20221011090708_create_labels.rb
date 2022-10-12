# frozen_string_literal: true

class CreateLabels < ActiveRecord::Migration[7.0]
  def change
    create_table :labels do |t|
      t.string :name, limit: 30, null: false, comment: 'ラベル名'

      t.timestamps
    end
  end
end
