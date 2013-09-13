class Api::MessagesController < Api::BaseController
  def index
    @messages = Message.all
    respond_with @messages
  end
  
  def create
    # Have to specify :api since it does not reference the correct namespace
    respond_with :api, Message.create!(params.permit(:body, :sender_name))
  end

  def destroy
    Message.destroy(params[:id])
    head :ok
  end
end