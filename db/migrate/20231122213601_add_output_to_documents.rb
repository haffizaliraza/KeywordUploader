class AddOutputToDocuments < ActiveRecord::Migration[7.0]
  def change
    add_column :documents, :output, :json
  end
end
