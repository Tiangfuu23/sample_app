# db/seeds.rb
# Tạo user đầu tiên
begin
  User.create!(
    name: "Tai Nguyen",
    email: "tainguyen2301@gmail.com",
    password: "password123",
    password_confirmation: "password123",
    birthday: Date.new(2003, 1, 23),
    gender: "male",
    admin: true,
    activated: true,
    activated_at: Time.zone.now
  )
rescue StandardError => e
  puts "Failed to create first user: #{e.message}"
end

# Tạo 99 users
99.times do |n|
  name = Faker::Name.name[0, 50]
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  birthday = Faker::Date.birthday(min_age: 18, max_age: 80)
  gender = User.genders.keys.sample

  begin
    User.create!(
      name: name,
      email: email,
      password: password,
      password_confirmation: password,
      birthday: birthday,
      gender: gender,
      activated: true,
      activated_at: Time.zone.now
    )
  rescue StandardError => e
    puts "Failed to create user #{n+1}: #{e.message}"
  end
end

puts "Created #{User.count} users"

# Tạo microposts
users = User.order(:created_at).take(6)
puts "Found #{users.count} users for microposts: #{users.map { |u| u&.id }.inspect}"
if users.empty? || users.any?(&:nil?)
  puts "No valid users found to create microposts"
else
  users.each do |user|
    next unless user&.persisted?
    puts "Creating microposts for user #{user.id}"
    30.times do
      content = Faker::Lorem.sentence(word_count: 5)
      begin
        user.microposts.create!(content: content)
      rescue StandardError => e
        puts "Failed to create micropost for user #{user.id}: #{e.message}"
      end
    end
  end
  puts "Created microposts for #{users.count} users"
end
