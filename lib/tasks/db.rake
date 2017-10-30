namespace :db do
  desc "
    Drop the sample DB, then insert production data.
    ex:
      rails db:overwrite DUMP_PATH=~/new_portal/lib/data/1718184516_airtailor_development.dump

  "

  task :terminate => :environment do
    ActiveRecord::Base.connection.execute <<-SQL
      SELECT
        pg_terminate_backend(pid)
      FROM
        pg_stat_activity
      WHERE
        -- don't kill my own connection!
        pid <> pg_backend_pid()
      AND
      -- don't kill the connections to other databases
        datname = '#{ActiveRecord::Base.connection.current_database}';
    SQL
  end

  task :overwrite => [:environment, :terminate] do |task, args|
      return "DO NOT WIPE PROD." if Rails.env == 'production'
      file_path = ENV['DUMP_PATH']
      file_path ||= default_file

      if File.exist?(file_path)
        # copy it to a new file
        # pg_restore --verbose --clean --no-acl --no-owner -h localhost -U galactus -d airtailor_development ./lib/data/latest.dump
        sh %{ pg_restore --verbose --clean --no-acl --no-owner -h localhost -d #{environment_db} #{file_path} }
        sh %{ bin/rails db:environment:set RAILS_ENV=#{Rails.env} }
      else
        puts "File not found or not given. Double-check the path."
      end
  end

  task :dump, [:file_path] => :environment do |task, args|
    file_path = args.file_path
    file_path ||= default_file

    file = File.new("#{file_path}", 'w')
    sh %{ pg_dump -Fc --no-acl --no-owner -h localhost #{environment_db} >> #{file_path}}

    puts file_path
  end

  def timestamp
    Time.now.strftime("%y%d%H%M%S")
  end

  def default_db_path
    "#{Rails.root}/lib/data"
  end

  def default_file
    "#{default_db_path}/#{timestamp}_db_dump.dump"
  end

  def environment_db
    "airtailor_#{Rails.env}"
  end

end
