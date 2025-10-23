# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Import CSV data if not already imported
if Student.count == 0
  puts "Importing CSV data..."
  # Use sample data for development
  csv_file_path = Rails.root.join('sample_data.csv')

  if File.exist?(csv_file_path)
    importer = CsvImporterService.new(csv_file_path)
    result = importer.import
    puts "Import completed: #{result[:imported]} records imported, #{result[:errors]} errors"
  else
    puts "CSV file not found at #{csv_file_path}"
    puts "Please ensure the dataset file is available"
  end
else
  puts "Data already imported. Student count: #{Student.count}"
end
