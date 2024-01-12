require 'httparty'
require 'benchmark'

namespace :load_test do
  desc 'Make API requests and measure performance'
  task :test_performance do
    api_url = 'http://127.0.0.1:3000/articles?query=error'  # Replace with your API endpoint
    num_requests = 1000  # Adjust as needed

    def make_api_request(api_url)
      begin
        response = HTTParty.get(api_url)
        return true  # Request successful
      rescue StandardError => e
        puts "Request failed: #{e.message}"
        return false  # Request failed
      end
    end

    successful_requests = 0
    threads = []

    time_elapsed = Benchmark.realtime do
      num_requests.times do
        threads << Thread.new do
          if make_api_request(api_url)
            successful_requests += 1
          end
        end
      end

      threads.each { |t| t.join }
    end

    puts "Successful Requests: #{successful_requests} out of #{num_requests}"
    puts "Requests per second: #{num_requests / time_elapsed}"
  end
end
