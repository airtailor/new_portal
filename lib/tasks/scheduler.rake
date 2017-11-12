desc "This task will mark orders late if it is passed their due date"
task :mark_orders_late => :environment do
  Order.active.past_due.update_all(late: true)
end
