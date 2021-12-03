class CtiChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "cti_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
