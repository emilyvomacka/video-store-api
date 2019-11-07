class CustomersController < ApplicationController
  CUSTOMER_KEYS = [:id, :name, :registered_at, :postal_code, :phone, :movies_checked_out_count]
  #return to :movies_checked_out_count
  
  def index
    customers = Customer.all 
    
    if ["name", "registered_at", "postal_code"].include? params[:sort]
      choice = params[:sort].to_sym
      customers = Customer.all.order(choice => :asc)
    end
    
    if params[:n] && params[:p]
      # I think these 2 query params are used together? otherwise p by itself makes no sense
      # TODO
    end
    
    render json: customers.as_json( only: CUSTOMER_KEYS), status: :ok
  end 
  
end
