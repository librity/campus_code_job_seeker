# frozen_string_literal: true

class Job < ApplicationRecord
  BRAZILIAN_MINIMUM_WAGE = 1039

  belongs_to :head_hunter

  validates :title, presence: true
  validates :description, presence: true
  validates :skills, presence: true
  validates :salary_floor,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: BRAZILIAN_MINIMUM_WAGE,
                            less_than: 50_000 }, presence: true
  validates :salary_roof, numericality: { only_integer: true, less_than: 50_200 },
                          presence: true
  validate :salary_roof_is_greater_than_salary_floor_by_at_least_200
  validates :position, presence: true
  validates :location, presence: true
  validates :retired, inclusion: { in: [true, false] }
  VALID_DATE_REGEX = /\d{4}-\d{2}-\d{2}/.freeze
  validates :expires_on, presence: true, format: { with: VALID_DATE_REGEX }
  validate :whether_expires_on_is_either_today_or_in_the_future
  validates :head_hunter, presence: true

  scope :by_head_hunter, ->(head_hunter) { where head_hunter: head_hunter }

  private

  def salary_roof_is_greater_than_salary_floor_by_at_least_200
    return if salary_floor.nil?
    return if salary_roof && salary_roof >= salary_floor + 200

    errors.add :salary_roof, :greater_than_or_equal_to, count: salary_floor + 200
  end

  def whether_expires_on_is_either_today_or_in_the_future
    return if expires_on_is_before_today?

    errors.add :expires_on, :cant_be_retroactive
  end

  def expires_on_is_before_today?
    expires_on && Date.today <= expires_on
  end
end