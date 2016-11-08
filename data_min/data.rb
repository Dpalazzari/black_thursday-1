ids = (1..30).to_a
quantity = (1..10).to_a
merchant_ids = (1..10).to_a
invoice_ids = (1..20).to_a
first_names = ["George Sr.", "Lucille", "G.O.B.", "Michael", "Lindsay", "Buster", "Oscar", "Annyong", "Maeby", "George Michael"]
last_name = "Bluth"
created_ats = ["2012-03-27 14:54:09 UTC","2012-04-28 14:54:09 UTC","2012-05-29 14:54:09 UTC","2012-06-27 14:54:09 UTC","2012-07-27 14:54:09 UTC","2012-08-27 14:54:09 UTC","2012-09-27 14:54:09 UTC","2012-10-27 14:54:09 UTC","2012-11-27 14:54:09 UTC","2012-12-27 14:54:09 UTC"]
updated_ats = ["2012-03-27 14:54:09 UTC","2012-04-28 14:54:09 UTC","2012-05-29 14:54:09 UTC","2012-06-27 14:54:09 UTC","2012-07-27 14:54:09 UTC","2012-08-27 14:54:09 UTC","2012-09-27 14:54:09 UTC","2012-10-27 14:54:09 UTC","2012-11-27 14:54:09 UTC","2012-12-27 14:54:09 UTC"]
unit_prices = (1000..2000).to_a
name = ["frozen banana","double-dipped frozen","the simple simon","the giddy-girly banana","the G.O.B.","The On the Go-Go Banana","The George Daddy","The Original Frozen Banana"]
description = "frozen banana"
status = ["pending","shipped","returned","pending","shipped"]
items = ids.map do |id|
  "#{id},#{name.shuffle[0]},#{description},#{unit_prices.shuffle[0]},#{merchant_ids.shuffle[0]},#{created_ats.shuffle[0]},#{updated_ats.shuffle[0]}"
end

invoices = invoice_ids.map do |id|
  "#{id},#{ids.shuffle[0]},#{ids.shuffle[0]},#{status.shuffle[0]},#{created_ats.shuffle[0]},#{updated_ats.shuffle[0]},#{unit_prices.shuffle[0]},#{created_ats.shuffle[0]},#{updated_ats.shuffle[0]}"
end

invoice_items = ids.map do |id|
  "#{id},#{ids.shuffle[0]},#{invoice_ids.shuffle[0]},#{quantity.shuffle[0]},#{unit_prices.shuffle[0]},#{created_ats.shuffle[0]},#{updated_ats.shuffle[0]}"
end

puts invoice_items
