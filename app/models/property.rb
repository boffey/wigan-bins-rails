class Property
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Serializers::JSON

  attribute :id
  attribute :value

  def attributes
    {'id' => nil, 'value' => nil}
  end

  def self.search(postcode)
    items = Array.new

    url = 'https://apps.wigan.gov.uk/MyNeighbourhood/Search.aspx?newSearch=1'
    options = {
      body: {
        __VIEWSTATE: "/wEPDwULLTE2NTIzMzkyNTUPZBYCZg9kFgICAw9kFgICAQ9kFgQCBA8PFgIeBFRleHRlZGQCBg8PFgIeB1Zpc2libGVoZBYCAgEPZBYCAgEPEGRkFgBkZMAkZP+oEksCCNEm8gn9q9H0QAH+e935XIs0kHP6Ajpq",
        __VIEWSTATEGENERATOR: "F01E8114",
        __EVENTVALIDATION: "/wEdAAMUzunLminT/bfA0/DsSKOMsaxNGBd52upyJ6GXbuouAI7zohCMBqNjam79gmP24YLORJpkkkqdE918XBoW8zz81VvFqbokN+dA3iop+5SXEA==",
        'ctl00$ContentPlaceHolder1$btnPostcodeSearch': "Search",
        'ctl00$ContentPlaceHolder1$txtPostcode': postcode
      }
    }

    response = HTTParty.post(url, options)
    parsed_body = Nokogiri::HTML(response.body)
    
    parsed_body.css('.Properties select option:not(.pleaseselect)').each do |property|
      value = property.attr('value')
      unless value == 'No Address records found.'
        item = self.new
        item.id = property.attr('value');
        item.value = property.text;
        items << item
      end
    end

    return items
  end
end