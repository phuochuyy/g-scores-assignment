class StudentsController < ApplicationController
  def show
    @student = Student.find_by_sbd(params[:sbd])

    if @student
      render :show
    else
      flash[:alert] = "Không tìm thấy học sinh với số báo danh: #{params[:sbd]}"
      redirect_to root_path
    end
  end

  def search
    @sbd = params[:sbd]
    if @sbd.present?
      redirect_to student_path(@sbd)
    else
      flash[:alert] = "Vui lòng nhập số báo danh"
      redirect_to root_path
    end
  end
end
