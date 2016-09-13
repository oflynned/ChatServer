require 'socket'

class Client
  def initialize(server)
    @server = server
    @request = nil
    @response = nil
    @username = nil

    #handle data synchronicity
    send_data
    listen

    #join threads on client kill
    @request.join
    @response.join
  end

  def send_data
    puts 'Enter a username:'

    @request = Thread.new do
      loop {
        msg = $stdin.gets.chomp
        @server.puts(msg)
      }
    end
  end

  def listen
    @response = Thread.new do
      loop {
        msg = @server.gets.chomp
        puts "#{msg}"
      }
    end
  end
end

server = TCPSocket.open('localhost', 3000)
Client.new(server)