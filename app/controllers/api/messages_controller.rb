class Api::MessagesController < ApplicationController
  before_action :authenticate_user!, except: [:create, :update]
  before_action :set_message, only: [:update]

  def create
    message = Message.create(message_params)
    if message.save
      data = message.conversation.as_json({include: [:messages => {include: [:store]}], methods: [:sender, :recipient]})
      render :json => data
    else
      render :json => {errors: message.errors.full_message}
    end
  end

  def update
    @message.update(message_params)
    if @message.save
      data = @message.conversation.as_json({include: [:messages => {include: [:store]}], methods: [:sender, :recipient]})
      render :json => data
    else
      render :json => {errors: message.errors.full_message}
    end
  end

 private

 def set_message
   @message = Message.find(params[:id])
 end

 def message_params
   params.require(:message).permit(:conversation_id, :store_id, :body, :recipient_read, :sender_read)
 end

end

