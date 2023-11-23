class DocumentProcessingJob < ApplicationJob
  queue_as :default

  def perform(document_id)
    document = Document.find(document_id)
    document.update(output: process_xlsx_file(document.xlsx_file))
  end

  private

  def process_xlsx_file(file)
    return unless file.is_a?(ActionDispatch::Http::UploadedFile)

    begin
      excel = Roo::Excelx.new(file.tempfile.path)
      # Process the XLSX file and return the output as a hash
      # For example:
      sheet = excel.sheet(0)
      output = sheet.each_row_streaming(offset: 1).map do |row|
        # Process each row as needed
        # For example, assume the first cell contains the data
        row[0].value
      end
      { rows: output }
    rescue Roo::FileNotFound, Roo::UnsupportedFileFormat => e
      # Handle exceptions if the file is not found or has an unsupported format
      Rails.logger.error("Error processing XLSX file: #{e.message}")
      { error: e.message }
    end
  end
end