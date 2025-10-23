module ApplicationHelper
  # Mapping từ tên môn học không dấu sang có dấu
  SUBJECT_NAMES = {
    "toan" => "Toán",
    "ngu_van" => "Ngữ văn",
    "ngoai_ngu" => "Ngoại ngữ",
    "vat_li" => "Vật lý",
    "hoa_hoc" => "Hóa học",
    "sinh_hoc" => "Sinh học",
    "lich_su" => "Lịch sử",
    "dia_li" => "Địa lý",
    "gdcd" => "GDCD"
  }.freeze

  def subject_name(subject_key)
    SUBJECT_NAMES[subject_key] || subject_key.humanize
  end

  def subject_names
    SUBJECT_NAMES
  end
end
