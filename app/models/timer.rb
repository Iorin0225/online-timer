class Timer < ApplicationRecord
  def reset!
    update! start_at: Time.current
  end
end
