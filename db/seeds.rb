# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

payment_methods = 'Dinheiro', 'Boleto', 'PIX', 'Cartão de Crédito',
  'Cartão de Débito', 'TED', 'DOC'

payment_methods.each do |payment_method|
  PaymentMethod.create name: payment_method, enabled: true
end


payment_methods_ids = PaymentMethod.pluck :id


innkeeper = FactoryBot.create :innkeeper, email: 'innkeeper@yandex.com', password: 'password'
inn = FactoryBot.create :inn, innkeeper: innkeeper
FactoryBot.create :address, inn: inn
FactoryBot.create :guest, email: 'guest@yandex.com', password: 'password'

payment_methods_ids.shuffle.take(3).each do |payment_method_id|
  InnPaymentMethod.create! inn: inn, payment_method_id: payment_method_id
end

4.times do
  FactoryBot.create :inn_room, inn: inn
end

100.times do
  innkeeper = FactoryBot.create :innkeeper, password: 'password'
  inn = FactoryBot.create :inn, innkeeper: innkeeper
  FactoryBot.create :address, inn: inn

  payment_methods_ids.shuffle.take(3).each do |payment_method_id|
    InnPaymentMethod.create! inn: inn, payment_method_id: payment_method_id
  end

  4.times do
    FactoryBot.create :inn_room, inn: inn
  end
end
