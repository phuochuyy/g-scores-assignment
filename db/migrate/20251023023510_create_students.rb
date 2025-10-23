class CreateStudents < ActiveRecord::Migration[8.0]
  def change
    create_table :students do |t|
      t.string :sbd, null: false
      t.decimal :toan, precision: 3, scale: 2
      t.decimal :ngu_van, precision: 3, scale: 2
      t.decimal :ngoai_ngu, precision: 3, scale: 2
      t.decimal :vat_li, precision: 3, scale: 2
      t.decimal :hoa_hoc, precision: 3, scale: 2
      t.decimal :sinh_hoc, precision: 3, scale: 2
      t.decimal :lich_su, precision: 3, scale: 2
      t.decimal :dia_li, precision: 3, scale: 2
      t.decimal :gdcd, precision: 3, scale: 2
      t.string :ma_ngoai_ngu

      t.timestamps
    end
    add_index :students, :sbd, unique: true
  end
end
