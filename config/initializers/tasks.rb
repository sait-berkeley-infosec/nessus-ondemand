scheduler = Rufus::Scheduler.new

scheduler.every("1m") do
  Scan.export!
end
