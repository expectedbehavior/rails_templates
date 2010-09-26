module Exceptional
  class Config
    class << self
      DEFAULTS[:disabled_by_default] = %w(development test cucumber culerity)
    end
  end
end
