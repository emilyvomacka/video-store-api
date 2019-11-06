class MoviesController < ApplicationController
  
  def index
    movies = Movie.all 
    
    render json: movies.as_json( only: [:id, :title, :release_date]), status: :ok
  end
  
  def show
    movie = Movie.find_by(id: params[:id])
    
    if movie
      render json: movie.as_json( only: [:id, :title, :overview, :release_date, :inventory, :available_inventory]), status: :ok
    else
      render json: { errors: "Movie not found" }, status: :ok
    end
  end
  
  def create
    movie = Movie.new(movie_params)
    movie.available_inventory = movie.inventory
    
    if movie.save
      render json: { msg: "Movie #{movie.title.capitalize} added to database", id: Movie.last.id }, status: :ok
    else
      render json: { errors: "Cannot add movie", error_msgs: movie.errors.full_messages }, status: :bad_request
    end
    return movie.id
  end
  
  private
  
  def movie_params
    return params.permit(:title, :overview, :release_date, :inventory)
  end
end
