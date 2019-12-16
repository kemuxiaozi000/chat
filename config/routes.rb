# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # namespace :rooms do
  #   get '/', action: 'show'
  # end
  # mount ActionCable.server => "/cable"
  root 'chat#show'
  namespace :chat do
    get '/', action: 'index'
    get 'show', action: 'show'
    post 'self_info', action: 'self_info'
    post 'search_user', action: 'search_user'
    post 'chat_brief', action: "chat_brief"
    post 'member_info_brief', action: "member_info_brief"
    post 'show_chat_record', action: "show_chat_record"
    post 'send_msg', action: "send_msg"
    post 'show_msg', action: "show_msg"
    post 'address_book', action: "address_book"
    get 'add_contact_search', action: "add_contact_search"
    post 'add_friend', action: "add_friend"
    post 'find_user', action: "find_user"
    post 'add_friend_accept', action: "add_friend_accept"
    post 'add_friend_ignore', action: "add_friend_ignore"
  end

  namespace :game do
    namespace :mario do
      get '/', action: 'index'
    end
    namespace :systemer do
      get '/', action: 'index'
    end
  end

    # get 'pdf/download/' => 'pdf#read'

    # get 'scroll/' => 'scroll#index'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
