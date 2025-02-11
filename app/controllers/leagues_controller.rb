class LeaguesController < ApplicationController
  def index
    render inertia: 'Leagues/Index', props: { leagues: League.all }
  end

  def new
    render inertia: 'Leagues/New'
  end
end
