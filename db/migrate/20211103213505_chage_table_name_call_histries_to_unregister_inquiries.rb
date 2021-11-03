class ChageTableNameCallHistriesToUnregisterInquiries < ActiveRecord::Migration[6.1]
  def change
    rename_table :call_histroys, :unregister_inquiries
  end
end
