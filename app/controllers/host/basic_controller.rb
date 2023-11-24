
class Host::BasicController < ApplicationController
  before_action :authenticate_innkeeper!
end
