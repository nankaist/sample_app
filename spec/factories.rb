# By using the symbol ':user', we get Factory Girl to simulate the user model.
Factory.define :user do |user|
  user.name         "Weichao Chou"
  user.email        "wchou@gmail.com"
  user.password     "foobar"
  user.password_confirmation  "foobar"
end

Factory.sequence :email do |n| # used to create lots of diff emails
  "person-#{n}@example.com"
end

Factory.define :micropost do |micropost| # define the micropost model
  micropost.content "Foo Bar"
  micropost.association :user
end