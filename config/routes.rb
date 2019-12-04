# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # namespace :rooms do
  #   get '/', action: 'show'
  # end
  # mount ActionCable.server => "/cable"
  root 'chat#index'
  namespace :chat do
    get '/', action: 'index'
    post 'self_info', action: 'self_info'
    post 'search_user', action: 'search_user'
    post 'chat_brief', action: "chat_brief"
    post 'member_info_brief', action: "member_info_brief"
    post 'chat_record', action: "chat_record"
    post 'send_msg', action: "send_msg"
    post 'show_msg', action: "show_msg"
    post 'address_book', action: "address_book"
  end

    # get 'pdf/download/' => 'pdf#read'

    # get 'scroll/' => 'scroll#index'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
