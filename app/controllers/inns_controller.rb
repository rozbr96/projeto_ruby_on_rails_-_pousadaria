
class InnsController < ApplicationController
  def index
    @inns = Inn.where enabled: true
  end

  def show
    @inn = Inn.find params[:id]
  end
end
