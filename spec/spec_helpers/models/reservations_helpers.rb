def make_invoiced_reservation_and_get_shop
  shop_with_invoiced_reservations = Shop.make()
  invoiced_reservation = Reservation.make()
  invoiced_reservation.board.creator = shop_with_invoiced_reservations
  invoiced_reservation.board.save
  existing_invoice = Invoice.make(:responsible_user=>shop_with_invoiced_reservations,
  :reservations=>[invoiced_reservation])
  
  shop_with_invoiced_reservations
end

def make_uninvoiced_reservation_and_get_shop
  uninvoiced_reservation = Reservation.make()
  shop_with_uninvoiced_reservations = Shop.make()
  uninvoiced_reservation.board.creator = shop_with_uninvoiced_reservations
  uninvoiced_reservation.board.save
  
  shop_with_uninvoiced_reservations
end