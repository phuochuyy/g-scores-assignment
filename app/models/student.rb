class Student < ApplicationRecord
  validates :sbd, presence: true, uniqueness: true, length: { is: 8 }

  SUBJECTS = %w[toan ngu_van ngoai_ngu vat_li hoa_hoc sinh_hoc lich_su dia_li gdcd].freeze
  GROUP_A_SUBJECTS = %w[toan vat_li hoa_hoc].freeze

  def self.find_by_sbd(sbd)
    find_by(sbd: sbd)
  end

  def group_a_average
    scores = GROUP_A_SUBJECTS.map { |subject| send(subject) }
    return 0 if scores.any?(&:nil?) # Return 0 if any subject is missing
    scores.sum / scores.size
  end

  def score_level(subject)
    score = send(subject)
    return nil if score.nil?

    case score
    when 8.0..10.0 then "excellent"
    when 6.0...8.0 then "good"
    when 4.0...6.0 then "average"
    else "poor"
    end
  end

  def has_group_a_scores?
    GROUP_A_SUBJECTS.all? { |subject| send(subject).present? }
  end
end
