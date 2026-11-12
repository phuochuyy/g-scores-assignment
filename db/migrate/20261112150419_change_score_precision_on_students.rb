class ChangeScorePrecisionOnStudents < ActiveRecord::Migration[8.0]
  # decimal(3,2) tops out at 9.99, so a perfect score of 10 overflowed on import.
  # decimal(4,2) stores up to 99.99. Raising precision with the same scale is
  # binary-compatible in PostgreSQL, so this does not rewrite the table.
  SCORE_COLUMNS = %i[toan ngu_van ngoai_ngu vat_li hoa_hoc sinh_hoc lich_su dia_li gdcd].freeze

  def up
    change_table :students, bulk: true do |t|
      SCORE_COLUMNS.each { |column| t.change column, :decimal, precision: 4, scale: 2 }
    end
  end

  # Fails if any score is 10 or higher, since it cannot fit back into decimal(3,2).
  def down
    change_table :students, bulk: true do |t|
      SCORE_COLUMNS.each { |column| t.change column, :decimal, precision: 3, scale: 2 }
    end
  end
end
