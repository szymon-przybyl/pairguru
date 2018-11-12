# == Resource Attributes
#
#  plot        :string
#  rating      :integer   1..5
#  poster_url  :string
#
class PairguruApi::Movie < ActiveResource::Base
  self.site = Pairguru::Application.config_for(:pairguru)['api_url']
end