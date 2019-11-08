class MoviesController < ApplicationController
  
  MOVIE_KEYS = [:id, :title, :overview, :release_date, :inventory, :available_inventory]
  
  before_action :get_movie, only: [:current, :history]
  before_action :get_query_params, only: [:index, :current, :history]
  
  def index
    
    if @approved_params
      movies = apply_query_params(array_of_objs: Movie.all, approved_params: @approved_params)
    else
      movies = Movie.all 
    end
    
    render json: movies.as_json( only: [:id, :title, :release_date]), status: :ok
    return
  end
  
  def show
    movie = Movie.find_by(id: params[:id])
    
    if movie
      render json: movie.as_json( only: MOVIE_KEYS), status: :ok
      return
    else
      render_errors_json(error: "Movie not found")
      return
    end
  end
  
  def create
    movie = Movie.new(movie_params)
    movie.available_inventory = movie.inventory
    
    if movie.save
      render json: { msg: "Movie #{movie.title.capitalize} added to database", id: Movie.last.id }, status: :ok
      return
    else
      render_errors_json(error: "Cannot add movie", error_msgs: movie.errors.full_messages)
      return
    end
  end
  
  def current
    current_rentals = get_active_rentals_from(instance: @movie)
    
    if @approved_params
      current_rentals = apply_query_params(array_of_objs: current_rentals, approved_params: @approved_params)
    end
    
    if current_rentals
      render json: current_rentals, status: :ok
      return
    else 
      render_error_json_bad_query_params
      return    
    end
  end
  
  def history
    # sends list of customers who've checked out a specific movie in the past
    past_rentals = get_past_rentals_from(instance: @movie)
    
    if @approved_params
      # any kind of params[:sort] declared by user would just be redundant and have zero effect
      past_rentals = apply_query_params(array_of_objs: past_rentals, approved_params: @approved_params)
    end
    
    if past_rentals
      render json: past_rentals, status: :ok
      return
    else
      render_error_json_bad_query_params
      return
    end
  end
  
  private
  
  def movie_params
    return params.permit(:title, :overview, :release_date, :inventory)
  end
  
  def get_movie
    ### in order for the found movie to be accessible, I *HAD* to add the @ in front of it, idk why
    @movie = get_db_object(model: Movie)
  end
  
  def get_query_params
    @approved_params = validate_query_params(acceptable_keys: ["title", "release_date"])
  end
end