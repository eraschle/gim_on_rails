# frozen_string_literal: true

# Module with common function for all gim models
module GimModelConcern
  extend ActiveSupport::Concern

  def generate_gim_id
    SecureRandom.uuid
  end
end
