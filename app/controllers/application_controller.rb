class ApplicationController < ActionController::API
  
  def zomg
    render json: { msgh: "yassss" }, status: :ok
  end
  
end
