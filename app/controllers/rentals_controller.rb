class RentalsController < ApplicationController
  
  def check_out
    ### CREATING a new rental record
    new_rental = Rental.new(rental_params)
    new_rental.checkout_date = Date.today
    new_rental.due_date = Date.today + 7.days
    new_rental.returned = false
    
    # does this movie even have available_inventory?
    movie = new_rental.movie
    if movie.available_inventory <= 0
      render json: { errors: "Cannot make a rental because movie #{movie.title.capitalize} ran out of copies"}, status: :bad_request
      return
    end
    
    if new_rental.save
      this_rental = Rental.last
      # update movie's avail count
      movie.update(available_inventory: movie.available_inventory - 1)
      
      # update custoemr's checked_out_count
      customer = this_rental.customer
      customer.update(movies_checked_out_count: customer.movies_checked_out_count + 1)
      
      # prep API JSON
      render json: { msg: "Rental id#{this_rental.id}: #{this_rental.movie.title} due on #{this_rental.due_date}"}, status: :ok
    else
      render json: { errors: "Cannot make a rental", error_msgs: new_rental.errors.full_messages }, status: :bad_request
    end
    
  end
  
  def check_in
    rental = Rental.find_by(movie_id: rental_params[:movie_id].to_i, customer_id: rental_params[:customer_id].to_i)
    # render json: { msg: "Rental id#{rental.id}: #{rental.movie.title} has been rented by #{rental.customer.name}." }, status: :ok
    # return 
    if rental.nil?
      render json: { errors: "Rental doesn't exist" }, status: :bad_request
      return 
    elsif rental.returned == true
      render json: { errors: "Rental has already been returned" }, status: :bad_request
      return
    else 
      this_customer = rental.customer
      this_customer.update(movies_checked_out_count: this_customer.movies_checked_out_count - 1)
      this_movie = rental.movie
      this_movie.update(available_inventory: this_movie.available_inventory + 1)
      render json: { msg: "Rental id#{rental.id}: #{rental.movie.title} has been returned." }, status: :ok
    end 
  end
  
  private
  
  def rental_params
    return params.permit(:movie_id, :customer_id)
  end
end
