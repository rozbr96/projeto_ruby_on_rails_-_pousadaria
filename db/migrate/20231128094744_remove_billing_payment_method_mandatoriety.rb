class RemoveBillingPaymentMethodMandatoriety < ActiveRecord::Migration[7.1]
  def change
    change_column_null :billings, :payment_method_id, true
  end
end
