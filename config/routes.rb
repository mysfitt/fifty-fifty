Rails.application.routes.draw do
  get 'fifty_fifty' => 'dictionaries#shuffle', :as => :fifty_fifty
end
