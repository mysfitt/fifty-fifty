class DictionariesController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :authenticate

  # 50/50. Half the responses are a random dictionary word, Half get a 503
  def shuffle
    r = Random.new
    success = r.rand(2)

    if success < 1
      return_unavailable
    else
      d = random
      render plain: d.word
    end
  end

  private
    TOKEN = "secret"

    # perform token auth
    def authenticate
      authenticate_or_request_with_http_token do |token, options|
        ActiveSupport::SecurityUtils.secure_compare(
          ::Digest::SHA256.hexdigest(token),
          ::Digest::SHA256.hexdigest(TOKEN)
        )
      end
    end

    def return_unavailable
      head :service_unavailable
    end

    # grab a random dictionary word
    def random
      # note that RANDOM will work in sqlite or Postgres, but not MySQL.
      # It would want RAND() instead. THANKS ORACLE!
      Dictionary.order("RANDOM()").first
    end
end
