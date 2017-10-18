namespace :db do
  desc "
    Drop the sample DB, then insert production data.
    ex:
      rails db:overwrite DUMP_PATH=~/new_portal/lib/data/1718184516_airtailor_development.dump

  "
  task :overwrite => [:environment, 'db:drop', 'db:create', 'db:migrate'] do |task, args|
      file_path = ENV['DUMP_PATH']
      if File.exist?(file_path)
        sh %{psql #{environment_db} < #{file_path}}
        sh %{rails db:seed}
      else
        puts "File not found or not given. Double-check the path."
      end
  end

  task :dump, [:file_path] => :environment do |task, args|
    file_path = args.file_path
    file_path ||= "#{default_db_path}/#{timestamp}_db_dump"

    file = File.new("#{file_path}", 'w')
    sh %{ pg_dump #{environment_db} >> #{file_path}}
  end

  def timestamp
    Time.now.strftime("%y%d%H%M%S")
  end

  def default_db_path
    "#{Rails.root}/lib/data"
  end

  def default_file
    "#{default_db_path}/#{timestamp}_db_dump"
  end

  def environment_db
    "airtailor_#{Rails.env}"
  end

end
