class Api::V1::StudentsController < ApplicationController
  def show
    @student = Student.find_by_sbd(params[:sbd])

    if @student
      render json: {
        sbd: @student.sbd,
        toan: @student.toan,
        ngu_van: @student.ngu_van,
        ngoai_ngu: @student.ngoai_ngu,
        vat_li: @student.vat_li,
        hoa_hoc: @student.hoa_hoc,
        sinh_hoc: @student.sinh_hoc,
        lich_su: @student.lich_su,
        dia_li: @student.dia_li,
        gdcd: @student.gdcd,
        ma_ngoai_ngu: @student.ma_ngoai_ngu,
        group_a_average: @student.group_a_average
      }
    else
      render json: { error: "Không tìm thấy học sinh với số báo danh: #{params[:sbd]}" }, status: :not_found
    end
  end
end
