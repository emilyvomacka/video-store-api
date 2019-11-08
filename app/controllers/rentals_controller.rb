class RentalsController < ApplicationController
  
  def check_out
    ### CREATING a new rental record
    new_rental = Rental.new(rental_params)
    new_rental.checkout_date = Date.today
    new_rental.due_date = Date.today + 7.days
    new_rental.returned = false
    
    if new_rental.movie.nil? || new_rental.customer.nil?
      new_rental.valid?
      render_errors_json(error: "Cannot make a rental", error_msgs: new_rental.errors.full_messages )
      return
    elsif new_rental.movie.available_inventory <= 0
      render_errors_json(error: "Cannot make a rental because movie #{new_rental.movie.title.capitalize} ran out of copies")
      return
    end
    
    if new_rental.save
      this_rental = Rental.last
      this_rental.movie.available_inventory_update(-1)
      this_rental.customer.movies_checked_out_update(1)
      render json: { msg: "Rental id #{this_rental.id}: #{this_rental.movie.title} due on #{this_rental.due_date}"}, status: :ok
      return
    else
      render_errors_json(error: "Cannot make a rental", error_msgs: new_rental.errors.full_messages)
      return
    end
  end
  
  def check_in
    rental = Rental.find_by(movie_id: rental_params[:movie_id].to_i, customer_id: rental_params[:customer_id].to_i)
    if rental.nil?
      render_errors_json(error:  "Rental doesn't exist" )
      return 
    elsif rental.returned == true
      render_errors_json(error: "Rental has already been returned" )
      return
    else 
      rental.customer.movies_checked_out_update(-1)
      rental.movie.available_inventory_update(1)
      rental.update(returned: true)
      render json: { msg: "Rental id #{rental.id}: #{rental.movie.title} has been returned." }, status: :ok
      return
    end 
  end
  
  def overdue
    possible_customers = Customer.where("movies_checked_out_count > ?", 0)
    overdue_customers = []
    
    possible_customers.each do |customer| 
      customer.rentals.each do |rental|
        unless rental.returned
          if rental.due_date.to_date < Date.today
            overdue_customers << customer
            # break out of this enumerable loop & move on to next customer
            break
          end
        end
      end
    end
    
    render json: overdue_customers, status: :ok
    return 
  end
  
  private
  
  def rental_params
    return params.permit(:movie_id, :customer_id)
  end
end
