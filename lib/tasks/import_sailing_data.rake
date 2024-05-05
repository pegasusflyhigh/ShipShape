namespace :import do
  desc "Import sailing data from JSON file"
  task json_data: [:environment] do
    file_path = ENV['FILE_PATH'] # Accessing the file path argument from the command line

    if file_path.blank?
      puts "Please provide the path to the JSON file using FILE_PATH argument."
      next
    end

    begin
      json_data = File.read(file_path)
      parsed_data = JSON.parse(json_data)

			service_response = DataImport::Import.new(parsed_data).call
      raise service_response.errors.inspect if service_response.failure?

			puts "Data imported successfully."
    rescue => e
      puts "Error importing data: #{e.message}"
    end
  end
end