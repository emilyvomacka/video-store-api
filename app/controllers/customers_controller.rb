class CustomersController < ApplicationController
  CUSTOMER_KEYS = [:id, :name, :registered_at, :postal_code, :phone, :movies_checked_out_count]
  #return to :movies_checked_out_count
  
  def index
    customers = Customer.all 
    
    if params[:sort]
      if ["name", "registered_at", "postal_code"].include? params[:sort]
        choice = params[:sort].to_sym
        customers = Customer.all.order(choice => :asc)
      else 
        render json: { errors: "Can't sort anything with that key" }, status: :bad_request
        return
      end
    end
    
    if params[:n] && params[:p]
      if (params[:n].respond_to? :to_i) && (params[:p].respond_to? :to_i)
        limit_amt = params[:n].to_i
        offset_amt = (params[:p].to_i - 1) * limit_amt
        
        if (limit_amt > 0) && (offset_amt > 0)
          customers = customers.limit(limit_amt).offset(offset_amt)
        else
          render json: { errors: "Invalid n & p combo" }, status: :bad_request
          return
        end
      end
    elsif params[:n] || params[:p]
      render json: { errors: "We require both n and p, not just one of them" }, status: :bad_request
      return
    end
    
    render json: customers.as_json( only: CUSTOMER_KEYS), status: :ok
    return
  end 
  
  def current
    #   Go through customerInstance.rentals, get all the ones with returned: false
    render json: { msg: "TODO" }, status: :ok
    
  end
  
  def history
    #  Go through customerInstance.rentals, get all the ones with returned: true
    render json: { msg: "TODO" }, status: :ok
    
  end
  
end
