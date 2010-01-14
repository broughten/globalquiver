every 1.day, :at=>'1:30am' do
  runner "User.send_reservation_update_for_owned_boards(1.day.ago)"
end
