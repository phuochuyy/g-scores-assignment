require "csv"

class CsvImporterService
  def initialize(file_path)
    @file_path = file_path
  end

  def import
    imported_count = 0
    error_count = 0

    CSV.foreach(@file_path, headers: true) do |row|
      begin
        student_data = {
          sbd: row["sbd"],
          toan: parse_score(row["toan"]),
          ngu_van: parse_score(row["ngu_van"]),
          ngoai_ngu: parse_score(row["ngoai_ngu"]),
          vat_li: parse_score(row["vat_li"]),
          hoa_hoc: parse_score(row["hoa_hoc"]),
          sinh_hoc: parse_score(row["sinh_hoc"]),
          lich_su: parse_score(row["lich_su"]),
          dia_li: parse_score(row["dia_li"]),
          gdcd: parse_score(row["gdcd"]),
          ma_ngoai_ngu: row["ma_ngoai_ngu"]
        }

        Student.create!(student_data)
        imported_count += 1

        # Log progress every 10000 records
        if imported_count % 10000 == 0
          puts "Imported #{imported_count} records..."
        end
      rescue => e
        error_count += 1
        puts "Error importing record #{row['sbd']}: #{e.message}"
      end
    end

    puts "Import completed. Imported: #{imported_count}, Errors: #{error_count}"
    { imported: imported_count, errors: error_count }
  end

  private

  def parse_score(value)
    return nil if value.blank?
    value.to_f
  end
end
