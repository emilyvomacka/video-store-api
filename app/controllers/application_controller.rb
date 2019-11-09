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
        per_page = params[:n].to_i
        page = params[:p].to_i
        
        if (per_page > 0) && (page > 0)
          approved_params[:per_page] = per_page
          approved_params[:page] = page
        else
          render json: { errors: "Invalid n & p combo" }, status: :bad_request
          return
        end
      else
        render json: { errors: "Invalid n or p query parameter(s)" }, status: :bad_request
      end
    elsif params[:n] || params[:p]
      render json: { errors: "We require both n and p, not just one of them" }, status: :bad_request
      return
    end
    
    return approved_params
  end
  
  def apply_query_params(array_of_objs:, approved_params:)
    
    if approved_params[:per_page] && approved_params[:page]
      index_of_first_target = approved_params[:per_page] * (approved_params[:page]-1)
      index_of_last_target = index_of_first_target + approved_params[:per_page] - 1
      array_of_objs = array_of_objs[index_of_first_target..index_of_last_target]
    end
    
    if approved_params[:sort]
      array_of_objs = array_of_objs.sort_by{ |obj| obj[approved_params[:sort].to_s] }
    end
    
    return array_of_objs
  end
  
  def render_errors_json(error: "An error has occurred, please call customer service 1-800-LOL-WHAT", error_msgs: nil)
    if error_msgs 
      render json: { error: error, error_msgs: error_msgs }, status: :bad_request
      return
    else
      render json: { error: error }, status: :bad_request
      return
    end
  end
  
  def render_error_json_bad_query_params
    render_error_json(error: "Nothing to show you b/c of bad query parameters")
    return
  end
  
  def get_db_object(model:)
    if params[:id].match? (/^\d+$/) 
      object = model.find_by(id: params[:id].to_i)
      
      if object.nil?
        render json: { error: "No #{model} match for id# #{params[:id]}" }, status: :bad_request
        return
      else
        return object
      end
      
    else
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
