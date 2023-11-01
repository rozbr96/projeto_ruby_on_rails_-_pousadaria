
class InnsController < ApplicationController
  def index
    @inns = Inn.where enabled: true
  end
end
