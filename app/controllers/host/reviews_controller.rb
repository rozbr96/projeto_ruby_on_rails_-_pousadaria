
class Host::ReviewsController < Host::BasicController
  before_action :set_review, only: [:reply, :replying]

  def index
    @reviews = Review.joins(:booking => :inn_room).where({
      bookings: {
        inn_rooms: { inn: current_innkeeper.inn }
      }
    })
  end

  def reply
    review_params = params.require(:review).permit :innkeeper_reply

    @review.update review_params

    redirect_to host_inn_reviews_path, notice: 'Avaliação respondida com sucesso'
  end

  def replying; end


  private

  def set_review
    @review = Review.find params[:review_id]
  end
end
