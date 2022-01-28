require 'serialport'
require 'net/https'
require 'uri'
require 'json'

class CtiServer
  def initialize(com_port, baud, data_bits, stop_bits, parity)
    @serialport = SerialPort.new(com_port, baud, data_bits, stop_bits, parity)
    @serialport.read_timeout = 10
  end

  def start
    loop do
      begin
        response = @serialport.readline
        
        datetime = get_datetime(data)
        telephone = get_telephone_number(data)

        send_webhook(datetime, telephone)
      rescue EOFError
        retry
      end
    end
  end

  private

  def send_webhook(datetime, telephone)
    url = URI.parse(Rails.configuration.x.app_setting[:webhook_url])
    http_client = Net::HTTP.new(url.host, url.port)
    
    send_data = build_send_data(datetime, telephone)

    request = Net::HTTP::POST.new(url.path)
    request.send_form_data(send_data)
    response = http_client.request(request)

    p response
  end

  def get_datetime(data)
    year = Date.today.year
    month = date.slice(0..1)
    day = date.slice(2..3)
    hour = date.slice(5..6)
    min = date.slice(7..8)

    return Time.new(year, month, day, hour, min)
  end

  def get_telephone_number(data)
    return data.slice(9..-1)
  end

  def build_send_data(datetime, telephone)
    data = {}
    inquiry = Inquiry.where(telephone: telephone)
                      .or(Inquiry.where(sub_telephone: telephone))
                      .order(datetime: :desc)
                      .order(start_time: :desc)
                      .first
    data[:inquiry_date] = datetime.strftime('%Y/%m/%d')
    data[:start_time] = datetime.strftime('%H:%M')
    data[:unknown_number_status] = 1
    data[:company_name] = inquiry.company_name
    data[:telephone_number] = telephone
    data[:inquirier_name] = inquiry.inquirier_name
    data[:inquirier_kind_id] = inquiry.inquirier_kind_id

    return data
  end
end

config = Rails.configuration.x.app_setting[:cti_settings]
cti = CtiServer.new(
  config[:com_port],
  config[:baud],
  config[:data_bits],
  config[:stop_bits],
  config[:parity],
)
cti.start
