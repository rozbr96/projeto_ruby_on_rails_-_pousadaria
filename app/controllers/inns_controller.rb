
class InnsController < ApplicationController
  def index
    inns = Inn.where(enabled: true).order(created_at: :desc).to_a

    @newest_inns = inns.shift 3
    @remaining_inns = inns
  end

  def show
    @inn = Inn.find params[:id]
  end
end
