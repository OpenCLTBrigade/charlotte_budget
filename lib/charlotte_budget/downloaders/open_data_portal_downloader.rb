require 'faraday'

# Data available at http://clt.charlotte.opendata.arcgis.com/datasets?q=budget
class OpenDataPortalDownloader
  
  def self.perform
    
    urls = [
      "/datasets/326b4503d3f140a5a9a80e97201a6efb_0.csv",
      "/datasets/db9833fde5ca4d5898a8b7a2c4202d2b_0.csv",
      "/datasets/47e3d319939746c98ca659a5aaf25a46_0.csv",
      "/datasets/6ca7b36b62a64916ab9c1211fc9a400d_0.csv",
      "/datasets/df572ee9389c410580b11945093e9787_0.csv",
      "/datasets/7d3175bd08244686ad562382b50b3870_0.csv"
    ]
    urls.each do |url|
      conn = Faraday.new(:url => "http://clt.charlotte.opendata.arcgis.com") do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
      response = conn.get(url)
      filename = response.headers["content-disposition"].split("=").last
      year = filename.split("_").first
      FileUtils.mkdir_p "processing/#{year}"
      File.open("processing/#{year}/#{filename}", "w+"){ |f| f.write(response.body) }
    end
  end
end