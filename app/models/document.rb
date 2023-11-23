class Document < ApplicationRecord

    has_many :results
    has_one_attached :xlsx_file
    validates :xlsx_file, presence: true

    after_create_commit :process_file_async

    def process_file_async
        DocumentProcessingJob.set(wait: 1.second).perform_later(id)
    end

end
