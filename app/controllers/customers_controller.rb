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
      limit_amt = params[:n].to_i
      offset_amt = (params[:p].to_i - 1) * limit_amt
      
      customers = customers.limit(limit_amt).offset(offset_amt)
    end
    
    # validations on query parameters? none... 
    # will just generate regular Customer.all if bogus params given for sort/n/p
    
    render json: customers.as_json( only: CUSTOMER_KEYS), status: :ok
  end 
  
end
