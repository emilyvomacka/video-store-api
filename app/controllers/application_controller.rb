class ApplicationController < ActionController::API
  
  def apply_query_params
    # refactor the query params into here...
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
