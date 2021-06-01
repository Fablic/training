class Label < ApplicationRecord
  belongs_to :user
  has_many :task_label_attachments, dependent: :destroy
  has_many :tasks, through: :task_label_attachments

  validates :name, presence: true, uniqueness: { scope: :user_id, case_sensitive: true }
  validate :check_color

  private

  def check_color
    return errors.add(:color, :blank) unless color

    # NOTE: This is based on https://developer.mozilla.org/en-US/docs/Web/CSS/color_value
    case color
    when /\A#\h{3}\z/
      # OK for #RGB
    when /\A#\h{4}\z/
      # OK for #RGBA
    when /\A#\h{6}\z/
      # OK for #RRGGBB
    when /\A#\h{8}\z/
      # OK for #RRGGBBAA
    else
      errors.add(:color, :hexadecimal_notation)
    end
  end
end
