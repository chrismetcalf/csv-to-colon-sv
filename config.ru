require "rubygems"
require "bundler/setup"
require "sinatra"
require "open-uri"
require "csv"

class ColonSV < Sinatra::Base
  get "/convert" do
    halt 400 if params[:source].nil?
    begin
      headers "Content-disposition" => "attachment; filename=#{params[:filename] || "download.csv"}"

      return CSV.generate({:col_sep => ";"}) do |csv|
        CSV.parse(open(params[:source])) do |row|
          csv << row
        end
      end
    rescue CSV::MalformedCSVError
      # Not a CSV
      halt 400, "That wasn't a CSV"
    rescue Exception
      # We broke-ded!
      halt 500, "Internal Error"
    end
  end

  get '/' do
    redirect "http://github.com/socrata/csv-to-colon-sv", 302
  end
end

run ColonSV
