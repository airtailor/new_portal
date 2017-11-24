class RetailersNeedPhones < ActiveRecord::Migration[5.1]
  def change
    Store.where(name: 'Air Tailor').update_all(phone: '6167804457')
    Store.where(name: 'Frame Denim - SoHo').update_all(phone: '6466935361')
  end
end
