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
    # Go through customerInstance.rentals, get all the ones with returned: false
    # @customer is from before_action get_customer()
    
    current_rentals = @customer.rentals.select { |rental| 
      !rental.returned
    }
    render json: current_rentals, status: :ok
    return
  end
  
  def history
    #  Go through customerInstance.rentals, get all the ones with returned: true
    # @customer is from before_action get_customer()
    past_rentals = @customer.rentals.select { |rental| 
      rental.returned
    }
    render json: past_rentals, status: :ok
    return
  end
  
  private
  def get_customer
    # gets & evals the params[:id] from URL request, returns either a JSON error msg or an actual customer instance
    ### in order for the found customer to be accessible, I *HAD* to add the @ in front of it, idk why
    if params[:id].match? (/^\d+$/)   # only accept chars of 0..9
      @customer = Customer.find_by(id: params[:id].to_i)
      
      if @customer.nil?
        render json: { error: "No customer match for id# #{params[:id]}" }, status: :bad_request
        return
      end
      
    else
      # regex match failed, params[:id] can't even be an integer
      render json: { error: "That id# #{params[:id]} is not even valid"}, status: :bad_request
      return
    end
  end
  
end
