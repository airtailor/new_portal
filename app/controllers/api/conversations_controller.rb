class Api::ConversationsController < ApplicationController
  #before_action :authenticate_user!
  before_action :authenticate_user!, except: [:new, :create, :edit, :update]
  before_action :set_conversation, only: [:show]

  def index
    conversations = current_user.store.conversations
    data = conversations.as_json({methods: [:sender, :recipient]})
    render :json => data
  end

  def show
    data = @conversation.as_json({include: [:messages => {include: [:store]}], methods: [:sender, :recipient]})
    render :json => data
  end

  def create
    sender = params[:conversation][:sender_id]
    recipient = params[:conversation][:recipient_id]

    if Conversation.between(sender, recipient).present?
      @conversation = Conversation.between(sender, recipient).first
   else
      @conversation = Conversation.create!(conversation_params)
   end
   render :json => @conversation.to_json
  end

 private

 def set_conversation
  @conversation = Conversation.find(params[:id])
 end

 def conversation_params
  params.require(:conversation).permit(:recipient_id, :sender_id)
 end
end

