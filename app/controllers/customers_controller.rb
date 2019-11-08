class CustomersController < ApplicationController
  CUSTOMER_KEYS = [:id, :name, :registered_at, :postal_code, :phone, :movies_checked_out_count]
  
  before_action :get_customer, only: [:current, :history]
  
  def index
    customers = Customer.all 
    
    if params[:sort]
      if ["name", "registered_at", "postal_code"].include? params[:sort]
        choice = params[:sort].to_sym
        customers = Customer.all.order(choice => :asc)
      else 
        render_errors_json(error: "Can't sort anything with that key")
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
          render_errors_json(error: "Invalid n & p combo" )
          return
        end
      end
    elsif params[:n] || params[:p]
      render_errors_json(error: "We require both n and p, not just one of them" )
      return
    end
    
    render json: customers.as_json( only: CUSTOMER_KEYS), status: :ok
    return
  end 
  
  def current
    # Go through customerInstance.rentals, get all the ones with returned: false
    # @customer is from before_action get_customer()
    current_rentals = get_active_rentals_from(instance: @customer)
    render json: current_rentals, status: :ok
    return
  end
  
  def history
    #  Go through customerInstance.rentals, get all the ones with returned: true
    # @customer is from before_action get_customer()
    past_rentals = get_past_rentals_from(instance: @customer)
    render json: past_rentals, status: :ok
    return
  end
  
  private
  def get_customer
    ### in order for the found customer to be accessible, I *HAD* to add the @ in front of it, idk why
    @customer = get_db_object(model: Customer)
  end
  
end
