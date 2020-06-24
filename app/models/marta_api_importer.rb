
class MartaAPIImporter

    def train_api_call
        #the url to receive train schedule information from
        url = "http://developer.itsmarta.com/RealtimeTrain/RestServiceNextTrain/GetRealtimeArrivals?apikey="+ENV['API_KEY']

        #store the url as a class object
        uri = URI.parse(url)

        # #sending a get request
        responsed = Net::HTTP.get_response(uri)

        #parse using json into an array
        train_array = JSON.parse(responsed.body)
    end





end
