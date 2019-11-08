class MoviesController < ApplicationController
  
  MOVIE_KEYS = [:id, :title, :overview, :release_date, :inventory, :available_inventory]
  
  before_action :get_movie, only: [:current, :history]
  
  def index
    movies = Movie.all 
    
    render json: movies.as_json( only: [:id, :title, :release_date]), status: :ok
  end
  
  def show
    movie = Movie.find_by(id: params[:id])
    
    if movie
      render json: movie.as_json( only: MOVIE_KEYS), status: :ok
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
  
  def current
    # sends list of customers who've checked out a specific movie right now
    current_rentals = get_active_rentals_from(instance: @movie)
    render json: current_rentals, status: :ok
    return    
  end
  
  def history
    # sends list of customers who've checked out a specific movie in the past
    past_rentals = get_past_rentals_from(instance: @movie)
    render json: past_rentals, status: :ok
    return
  end
  
  private
  
  def movie_params
    return params.permit(:title, :overview, :release_date, :inventory)
  end
  
  def get_movie
    ### in order for the found movie to be accessible, I *HAD* to add the @ in front of it, idk why
    @movie = get_db_object(model: Movie)
  end
end