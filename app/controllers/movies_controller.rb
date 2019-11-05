class MoviesController < ApplicationController
 
  def index
    movies = Movie.all 
    
    render json: movies.as_json( only: [:id, :title, :release_date]), status: :ok
  end
  
  def show
    movie = Movie.find_by(id: params[:id])
    
    if movie
      render json: movie.as_json( only: [:id, :title, :overview, :release_date, :inventory, :avail_inventory]), status: :ok
    else
      render json: { errors: "Movie not found" }, status: :ok
      
    end
  end
  
  def create

  end
  
end
