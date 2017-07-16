Rails.application.routes.draw do

  root 'api#home'
  
  get  'api/home',         to: 'api#home',         as: :photo_home
  post 'api/photo_upload', to: 'api#photo_upload', as: :photo_upload
  get  'api/photo_list',   to: 'api#photo_list',   as: :photo_list

end

