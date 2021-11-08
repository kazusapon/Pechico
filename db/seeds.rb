# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 初期ユーザ登録
if User.count < 1
  User.create!(
    name: '管理者',
    login_id: 'admin',
    password: 'password',
    password_confirmation: 'password'
  )
end

# 新着問合せ登録
UnregisterInquiry.destroy_all
user = User.first
10.times do
  UnregisterInquiry.create!(
    user_id: user.id,
    company_name: 'テスト工業株式会社',
    telephone_number: '0852-22-3455',
    inquiry_date: Time.zone.now.strftime('%Y-%m-%d'),
    start_time: '10:20',
    end_time: '13:00',
    inquirier_name: 'テスト太郎',
    inquirer_kind_id: InquirierKind.first.id,
    unknown_number_status: 10
  )
end
