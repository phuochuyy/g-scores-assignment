class Api::V1::ReportsController < ApplicationController
  def statistics
    @service = StatisticsService.new
    @statistics = @service.all_subjects_statistics

    render json: @statistics
  end

  def top_students
    @service = StatisticsService.new
    @top_students = @service.top_group_a_students

    result = @top_students.map do |student|
      {
        sbd: student.sbd,
        group_a_average: student.group_a_average.round(2),
        toan: student.toan,
        vat_li: student.vat_li,
        hoa_hoc: student.hoa_hoc
      }
    end

    render json: result
  end
end
