class MakeDocumentsPolymorphic < ActiveRecord::Migration
  def change
    rename_column :documents, :project_id, :documentable_id
    add_column :documents, :documentable_type, :string
    add_index :documents, :documentable_id
    Document.reset_column_information
    Document.update_all(:documentable_type => "Project")
  end
end
