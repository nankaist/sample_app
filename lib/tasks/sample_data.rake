namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
  admin = User.create!(:name => "Weichao",
                :email => "nankaist@hotmail.com",
                :password => "tsiaknan",
                :password_confirmation => "tsiaknan")
  # populate an admin user
  # we must use toggle!(:admin) to change it true, 
  # not by setting :admin => true because it is not accessible defined by attr_accessible
  admin.toggle!(:admin) 
  99.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password = 'password'
    User.create!(:name => name,
                  :email => email,
                  :password => password,
                  :password_confirmation => password)
  end
end
    
    
def make_microposts
  User.all(:limit => 10).each do |user|
    50.times do
      user.microposts.create!(:content => Faker::Lorem.sentence(5))
    end
  end 
end

def make_relationships
  users = User.all
  user = users.first
  following = users[1..50]
  followers = users[3..40]
  following.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end