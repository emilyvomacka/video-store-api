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
    ### Modifying existing rental record flip status to returned: true
    # CHRIS SAID... the client wanted a POST, even though we're doing UPDATE here,
    # just stick to the client's specs...
    
  end
  
  private
  
  def rental_params
    return params.require(:rental).permit(:movie_id, :customer_id)
  end
end
