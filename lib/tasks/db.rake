namespace :db do
  desc "Drop the sample DB, then insert production data."
  task :overwrite, [:file_path] => :environment do |task, args|
    sh %{ rails db:reset }

    file_path = args.file_path
    file_path ||= default_db_path
    if File.exist?(file_path)
      sh %{psql airtailor_#{env} << #{file_path}}
    end

    sh %{rails db:seed}
  end

  task :dump, [:file_path] => :environment do |task, args|
    file_path = args.file_path
    file_path ||= default_db_path
    sh %{ pg_dump #{environment_db} >> #{file_path}}
  end

  def default_db_path
    "#{Rails.root}/lib/data/db_import"
  end

  def environment_db
    "airtailor_#{Rails.env}"
  end

end
