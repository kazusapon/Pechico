require 'serialport'
require 'net/https'
require 'uri'
require 'json'

module CtiServer
  class Wrapper
    class << self
      def start
        puts 'CTIServer Reading Started'
        serialport = init_serialport

        loop do
          begin
            received_data = serialport.readline

            datetime = get_datetime(received_data)
            telephone = get_telephone_number(received_data)

            send_webhook(datetime, telephone)

          rescue EOFError
            retry
          end
        end
      end

      private

      def init_serialport
        config = Rails.configuration.x.app_setting[:cti_settings]
        serialport = SerialPort.new(
          config[:com_port],
          config[:baud],
          config[:data_bits],
          config[:stop_bits],
          config[:parity],
        )
        serialport.read_timeout = 5

        return serialport
      end

      def send_webhook(datetime, telephone)
        url = URI.parse(Rails.configuration.x.app_setting[:webhook_url])
        http_client = Net::HTTP.new(url.host, url.port)
        
        send_data = build_send_data(datetime, telephone)

        request = Net::HTTP::Post.new(url.path)
        request.set_form_data(send_data)
        
        response = http_client.request(request)
        p response # DEBUG
      end

      def get_datetime(data)
        year = Date.today.year
        month = data.slice(0..1)
        day = data.slice(2..3)
        hour = data.slice(5..6)
        min = data.slice(7..8)

        return Time.new(year, month, day, hour, min, 0)
      end

      def get_telephone_number(data)
        return data.slice(9..-1)
      end

      def build_send_data(datetime, telephone)
        prev_inquiry = Inquiry.get_prev_inquiry(telephone)

        data = {}
        data[:inquiry_date] = datetime.strftime('%Y/%m/%d')
        data[:start_time] = datetime.strftime('%H:%M')
        data[:unknown_number_status] = 1
        data[:company_name] = prev_inquiry.try!(:company_name)
        data[:telephone_number] = telephone
        data[:inquirier_name] = prev_inquiry.try!(:inquirier_name)
        data[:inquirier_kind_id] = prev_inquiry.try!(:inquirier_kind_id)

        return data
      end
    end
  end
end
