User.create!(
  name: "Tai Nguyen",
  email: "tainguyen2301@gmail.com",
  password: "123",
  password_confirmation: "123",
  birthday: Date.new(2003, 1, 23),
  gender: "male",
  admin: true
)

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  birthday = Faker::Date.birthday(min_age: 18, max_age: 80)
  gender = User.genders.keys.sample

  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    birthday: birthday,
    gender: gender
  )
end
