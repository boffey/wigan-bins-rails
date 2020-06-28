class Collection
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Serializers::JSON

  attribute :name
  attribute :date, :date

  def attributes
    {'name' => nil, 'date' => nil}
  end

  def self.for_property(property)
    collections = Rails.cache.fetch("#{property}/collections", expires_in: 1.days) do
      get_collections(property)
    end

    return collections
  end

  private
    def self.get_collections(property)
      Rails.logger.info "Cache Miss"
      
      collections = Array.new

      url = 'https://apps.wigan.gov.uk/MyNeighbourhood/MyArea.aspx'
      options = {
        cookies: { WiganCouncilUPRN: property }
      }
      response = HTTParty.get(url, options)
      parsed_body = Nokogiri::HTML(response.body)
      
      parsed_body.css('.dragbox.BinsRecycling').each do |bin|
        collection = self.new
        collection.name = bin.css('h2').first.text

        date_text = bin.css('.dateWrapper-next').first.text
        collection.date = Date.parse(date_text);

        collections << collection if collection.date.between?(Date.today, (Date.today + 7.days))
      end

      return collections
    end
end