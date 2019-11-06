class CustomersController < ApplicationController
  CUSTOMER_KEYS = [:id, :name, :registered_at, :postal_code, :phone, :movies_checked_out_count]
  #return to :movies_checked_out_count
  
  def index
    customers = Customer.all 
    render json: customers.as_json( only: CUSTOMER_KEYS), status: :ok
  end 
end
