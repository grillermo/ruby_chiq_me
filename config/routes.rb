Rails.application.routes.draw do
  get '*alias', controller: :shorteners, action: :show, as: :alias

  post '/', controller: :shorteners, action: :create, as: :shortener
end
