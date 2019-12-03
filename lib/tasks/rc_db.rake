namespace :rc_db do
  desc 'ローカルRDMへのMigrate'
  task local_migrate: :environment do
    RAILS_ENV.freeze = 'test'
    Rake::Task['db:migrate'].invoke
  end

  desc '共有サーバーRDMへのMigrate'
  task public_migrate: :environment do
    RAILS_ENV.freeze = 'development'
    Rake::Task['db:migrate'].invoke
  end

  desc 'ローカルRDMへのseed'
  task local_seed: :environment do
    RAILS_ENV.freeze = 'test'
    Rake::Task['db:seed'].invoke
  end

  desc '共有サーバーRDMへのseed'
  task public_seed: :environment do
    RAILS_ENV.freeze = 'development'
    Rake::Task['db:seed'].invoke
  end
end
