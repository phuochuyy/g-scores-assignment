class StatisticsService
  def initialize
    @students = Student.all
  end

  def subject_statistics(subject)
    levels = %w[excellent good average poor]
    levels.map do |level|
      {
        level: level,
        count: count_by_level(subject, level),
        percentage: percentage_by_level(subject, level)
      }
    end
  end

  def top_group_a_students(limit = 10)
    @students.select { |s| s.has_group_a_scores? }
             .sort_by(&:group_a_average)
             .reverse
             .first(limit)
  end

  def all_subjects_statistics
    Student::SUBJECTS.each_with_object({}) do |subject, result|
      result[subject] = subject_statistics(subject)
    end
  end

  private

  def count_by_level(subject, level)
    @students.count { |s| s.score_level(subject) == level }
  end

  def percentage_by_level(subject, level)
    total = @students.count { |s| !s.send(subject).nil? }
    return 0 if total.zero?
    (count_by_level(subject, level).to_f / total * 100).round(2)
  end
end
