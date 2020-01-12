# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
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
    post 'show_chat_record', action: "show_chat_record"
    post 'send_msg', action: "send_msg"
    post 'address_book', action: "address_book"
    get 'add_contact_search', action: "add_contact_search"
    post 'add_friend', action: "add_friend"
    post 'find_user', action: "find_user"
    post 'add_friend_accept', action: "add_friend_accept"
    post 'add_friend_ignore', action: "add_friend_ignore"
    post 'edit_profile', action: "edit_profile"
    post 'avatar_upload', action: "avatar_upload"
    post 'notename_revise', action: "notename_revise"
    post 'start_group_chat', action: "start_group_chat"
    post 'find_group_member', action: "find_group_member"
    post 'attachment_upload', action: "attachment_upload"
    get 'attachment_download', action: "attachment_download"
    post 'search_uid_by_channel', action: "search_uid_by_channel"
    post 'chat_preview', action: "chat_preview"
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
