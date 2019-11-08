class ApplicationController < ActionController::API
  
  def validate_query_params(acceptable_keys:)
    approved_params = {}
    
    if params[:sort]
      if acceptable_keys.include? params[:sort]
        approved_params[:sort] = params[:sort]
      else 
        render json: { errors: "Can't sort anything with key of #{params[:sort]}" }, status: :bad_request
        return
      end
    end
    
    if params[:n] && params[:p]
      if (params[:n].match? (/^\d+$/)) && (params[:p].match? (/^\d+$/))
        # only valid integers will make it to this point
        limit_amt = params[:n].to_i
        offset_amt = (params[:p].to_i - 1) * limit_amt
        
        if (limit_amt > 0) && (offset_amt >= 0)
          approved_params[:limit_amt] = limit_amt
          approved_params[:offset_amt] = offset_amt
        else
          render json: { errors: "Invalid n & p combo" }, status: :bad_request
          return
        end
      end
    elsif params[:n] || params[:p]
      render json: { errors: "We require both n and p, not just one of them" }, status: :bad_request
      return
    end
    
    return approved_params
  end
  
  def apply_query_params(array_of_objs:, approved_params:)
    
    # do this first to lower amount to sort later
    if approved_params[:limit_amt] && approved_params[:offset_amt]
      limit_amt = approved_params[:limit_amt]
      offset_amt = approved_params[:offset_amt]
      array_of_objs = array_of_objs.limit(limit_amt).offset(offset_amt)
    end
    
    if approved_params[:sort]
      array_of_objs = array_of_objs.sort_by{ |obj| obj[approved_params[:sort].to_s] }
    end
    
    return array_of_objs
  end
  
  def get_db_object(model:)
    # gets & evals the params[:id] from URL request, returns either a JSON error msg or an actual customer instance
    if params[:id].match? (/^\d+$/)   # only accept chars of 0..9
      object = model.find_by(id: params[:id].to_i)
      
      if object.nil?
        render json: { error: "No #{model} match for id# #{params[:id]}" }, status: :bad_request
        return
      else
        return object
      end
      
    else
      # regex match failed, params[:id] can't even be an integer
      render json: { error: "That id# #{params[:id]} is not even valid"}, status: :bad_request
      return
    end
  end
  
  def get_active_rentals_from(instance:)
    return instance.rentals.select { |rental| !rental.returned }
  end
  
  def get_past_rentals_from(instance:)
    return instance.rentals.select { |rental| rental.returned }
  end
end
