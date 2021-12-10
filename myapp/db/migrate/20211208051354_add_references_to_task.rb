class AddReferencesToTask < ActiveRecord::Migration[6.0]
  def change
    add_reference :tasks, :user, foreign_key: true, after: :status
    # rubocopでRails/NotNullColumnに引っ掛かるため以下でnull制約対応
    change_column_null :tasks, :user_id, false
  end
end
