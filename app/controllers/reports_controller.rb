class ReportsController < ApplicationController
  def statistics
    @service = StatisticsService.new
    @subjects = Student::SUBJECTS
    @statistics = @service.all_subjects_statistics
  end

  def top_students
    @service = StatisticsService.new
    @top_students = @service.top_group_a_students
  end
end
