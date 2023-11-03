
class OwnInnController < ApplicationController
  def show
    @inn = current_innkeeper.inn
  end
end
