Rails.application.routes.draw do
  root "home#index"

  get "search", to: "students#search"
  get "students/:sbd", to: "students#show", as: "student"

  get "reports/statistics", to: "reports#statistics"
  get "reports/top_students", to: "reports#top_students"

  # API routes
  namespace :api do
    namespace :v1 do
      get "students/:sbd", to: "students#show"
      get "reports/statistics", to: "reports#statistics"
      get "reports/top_students", to: "reports#top_students"
    end
  end

  # Test route for flash messages
  get "test_flash", to: "home#test_flash"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
