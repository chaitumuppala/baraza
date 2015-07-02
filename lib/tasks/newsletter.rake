namespace :db do
  desc "Create newsletter"
  task :newsletter => :environment do
    Newsletter.create(name: "Newsletter for the month of #{Date.today.strftime("%B")}")
  end
end