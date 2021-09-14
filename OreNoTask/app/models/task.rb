class Task < ApplicationRecord
	include DatetimeIntegratable
		REGISTRABLE_ATTRIBUTES = %i(
		    name
		    description
		    status
		    start_at_date start_at_hour start_at_minute
		    due_date_at_date due_date_at_hour due_date_at_minute
		    deleted
	    )

	integrate_datetime_fields(:due_date_at, :start_at)

	validates :start_at_date, presence: true
	validates :start_at_hour, presence: true
	validates :start_at_minute, presence: true

	validates :due_date_at_date, presence: true
	validates :start_at_hour, presence: true
	validates :start_at_minute, presence: true
end
