class RenameInquiryRelationIdToParentInquiryIdFromInquiry < ActiveRecord::Migration[6.1]
  def change
    rename_column :inquiries, :inquiry_relation_id, :parent_inquiry_id
  end
end
