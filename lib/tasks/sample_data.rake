namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
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
end