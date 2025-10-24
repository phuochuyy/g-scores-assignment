class StudentsController < ApplicationController
  def show
    sbd = params[:sbd]&.strip

    # Validate SBD format first
    unless valid_sbd_format?(sbd)
      flash[:alert] = "Số báo danh không hợp lệ"
      redirect_to root_path
      return
    end

    @student = Student.find_by_sbd(sbd)

    if @student
      render :show
    else
      flash[:alert] = "Không tìm thấy học sinh với số báo danh: #{sbd}"
      redirect_to root_path
    end
  end

  def search
    @sbd = params[:sbd]&.strip

    # Validate SBD format
    if @sbd.blank?
      flash[:alert] = "Vui lòng nhập số báo danh"
      redirect_to root_path
      return
    end

    unless valid_sbd_format?(@sbd)
      flash[:alert] = "Số báo danh phải có đúng 8 chữ số"
      redirect_to root_path
      return
    end

    # Check if student exists
    if Student.exists?(sbd: @sbd)
      redirect_to student_path(@sbd)
    else
      flash[:alert] = "Không tìm thấy học sinh với số báo danh: #{@sbd}"
      redirect_to root_path
    end
  end
end
