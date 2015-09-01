Elasticsearch::Model.client = Elasticsearch::Client.new log: !Rails.env.test?
