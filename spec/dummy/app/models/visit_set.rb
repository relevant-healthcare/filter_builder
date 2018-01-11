class VisitSet
  class << self
    def find_by(params)
      new(visits_procs_by_id[params[:id]])
    end

    private

    def visits_procs_by_id
      @visits_procs_by_id ||= {
        uds: -> { Visit.where(uds_universe: true) }
      }
    end
  end

  attr_reader :visits_proc

  def initialize(visits_proc)
    @visits_proc = visits_proc
  end

  def visits
    visits_proc.call
  end
end
