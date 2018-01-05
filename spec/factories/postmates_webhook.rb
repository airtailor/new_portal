module POSTMATES_WEBHOOK
  def self.status_pickup
    return {
      "status" => "pickup",
      "kind" => "event.delivery_status",
      "created" => "2017-12-18T21:06:35Z", "delivery_id" => "del_LYVhhdw8GjKOr-", "data" => {
          "status" => "pickup", "dropoff" => {
              "phone_number" => "+19174544874", "name" => "About the Stitch", "notes" => "Unit: #710", "detailed_address" => {
                  "city" => "New York", "country" => "US", "street_address_1" => "325 West 38th Street", "street_address_2" => "", "state" => "NY", "sublocality_level_1" => nil, "zip_code" => "10018"
              }, "location" => {
                  "lat" => 40.75542009999999, "lng" => -73.9927316
              }, "address" => "325 West 38th Street"
          }, "updated" => "2017-12-18T21:06:35Z", "fee" => 946, "quote_id" => "dqt_LYVhh_EtvJ6btk", "complete" => false, "courier" => {
              "phone_number" => "", "rating" => "5.0", "name" => "Ninetales R.", "img_href" => "https://d2abve4vv95fsr.cloudfront.net/rGhcwaUFkqzeiQyP1_npIbcdGcg=/288x288/smart/com.postmates.img.prod.s3.amazonaws.com/e1013253-604b-44a9-b531-40e695371840/orig.jpg", "location" => {
                  "lat" => 40.768397942097984, "lng" => -73.94880942725423
              }, "vehicle_type" => "van"
          }, "created" => "2017-12-18T21:05:58Z", "tip" => nil, "kind" => "delivery", "manifest" => {
              "description" => "If you have problems with the delivery and cannot reach anyone at the pickup or dropoff phone, please call Brian at (616) 780-4457"
          }, "currency" => "usd", "pickup" => {
              "phone_number" => "+12122554848", "name" => "J.Crew - 5th Ave", "notes" => "", "detailed_address" => {
                  "city" => "New York", "country" => "US", "street_address_1" => "91 5th Avenue", "street_address_2" => "", "state" => "NY", "sublocality_level_1" => nil, "zip_code" => "10003"
              }, "location" => {
                  "lat" => 40.737633, "lng" => -73.9922022
              }, "address" => "91 5th Avenue"
          }, "dropoff_identifier" => "", "live_mode" => false, "dropoff_deadline" => "2017-12-18T21:45:58Z", "related_deliveries" => [], "pickup_eta" => nil, "dropoff_eta" => nil, "id" => "del_LYVhhdw8GjKOr-"
      }, "id" => "evt_LYVhqo5H_3GOxF", "format" => "json", "controller" => "api/postmates", "action" => "receive",
      "postmate" => {
          "status" => "pickup", "kind" => "event.delivery_status", "created" => "2017-12-18T21:06:35Z", "live_mode" => false, "delivery_id" => "del_LYVhhdw8GjKOr-", "data" => {
              "status" => "pickup", "dropoff" => {
                  "phone_number" => "+19174544874", "name" => "About the Stitch", "notes" => "Unit: #710", "detailed_address" => {
                      "city" => "New York", "country" => "US", "street_address_1" => "325 West 38th Street", "street_address_2" => "", "state" => "NY", "sublocality_level_1" => nil, "zip_code" => "10018"
                  }, "location" => {
                      "lat" => 40.75542009999999, "lng" => -73.9927316
                  }, "address" => "325 West 38th Street"
              }, "updated" => "2017-12-18T21:06:35Z", "fee" => 946, "quote_id" => "dqt_LYVhh_EtvJ6btk", "complete" => false, "courier" => {
                  "phone_number" => "", "rating" => "5.0", "name" => "Ninetales R.", "img_href" => "https://d2abve4vv95fsr.cloudfront.net/rGhcwaUFkqzeiQyP1_npIbcdGcg=/288x288/smart/com.postmates.img.prod.s3.amazonaws.com/e1013253-604b-44a9-b531-40e695371840/orig.jpg", "location" => {
                      "lat" => 40.768397942097984, "lng" => -73.94880942725423
                  }, "vehicle_type" => "van"
              }, "created" => "2017-12-18T21:05:58Z", "tip" => nil, "kind" => "delivery", "manifest" => {
                  "description" => "If you have problems with the delivery and cannot reach anyone at the pickup or dropoff phone, please call Brian at (616) 780-4457"
              }, "currency" => "usd", "pickup" => {
                  "phone_number" => "+12122554848", "name" => "J.Crew - 5th Ave", "notes" => "", "detailed_address" => {
                      "city" => "New York", "country" => "US", "street_address_1" => "91 5th Avenue", "street_address_2" => "", "state" => "NY", "sublocality_level_1" => nil, "zip_code" => "10003"
                  }, "location" => {
                      "lat" => 40.737633, "lng" => -73.9922022
                  }, "address" => "91 5th Avenue"
              }, "dropoff_identifier" => "", "live_mode" => false, "dropoff_deadline" => "2017-12-18T21:45:58Z", "related_deliveries" => [], "pickup_eta" => nil, "dropoff_eta" => nil, "id" => "del_LYVhhdw8GjKOr-"
          }, "id" => "evt_LYVhqo5H_3GOxF"
      }
  }
  end

  def self.status_pickup_complete
    return {
      "status" => "pickup_complete",
      "kind" => "event.delivery_status",
      "created" => "2017-12-18T21:06:35Z", "delivery_id" => "del_LYVhhdw8GjKOr-", "data" => {
          "status" => "pickup_complete", "dropoff" => {
              "phone_number" => "+19174544874", "name" => "About the Stitch", "notes" => "Unit: #710", "detailed_address" => {
                  "city" => "New York", "country" => "US", "street_address_1" => "325 West 38th Street", "street_address_2" => "", "state" => "NY", "sublocality_level_1" => nil, "zip_code" => "10018"
              }, "location" => {
                  "lat" => 40.75542009999999, "lng" => -73.9927316
              }, "address" => "325 West 38th Street"
          }, "updated" => "2017-12-18T21:06:35Z", "fee" => 946, "quote_id" => "dqt_LYVhh_EtvJ6btk", "complete" => false, "courier" => {
              "phone_number" => "", "rating" => "5.0", "name" => "Ninetales R.", "img_href" => "https://d2abve4vv95fsr.cloudfront.net/rGhcwaUFkqzeiQyP1_npIbcdGcg=/288x288/smart/com.postmates.img.prod.s3.amazonaws.com/e1013253-604b-44a9-b531-40e695371840/orig.jpg", "location" => {
                  "lat" => 40.768397942097984, "lng" => -73.94880942725423
              }, "vehicle_type" => "van"
          }, "created" => "2017-12-18T21:05:58Z", "tip" => nil, "kind" => "delivery", "manifest" => {
              "description" => "If you have problems with the delivery and cannot reach anyone at the pickup or dropoff phone, please call Brian at (616) 780-4457"
          }, "currency" => "usd", "pickup" => {
              "phone_number" => "+12122554848", "name" => "J.Crew - 5th Ave", "notes" => "", "detailed_address" => {
                  "city" => "New York", "country" => "US", "street_address_1" => "91 5th Avenue", "street_address_2" => "", "state" => "NY", "sublocality_level_1" => nil, "zip_code" => "10003"
              }, "location" => {
                  "lat" => 40.737633, "lng" => -73.9922022
              }, "address" => "91 5th Avenue"
          }, "dropoff_identifier" => "", "live_mode" => false, "dropoff_deadline" => "2017-12-18T21:45:58Z", "related_deliveries" => [], "pickup_eta" => nil, "dropoff_eta" => nil, "id" => "del_LYVhhdw8GjKOr-"
      }, "id" => "evt_LYVhqo5H_3GOxF", "format" => "json", "controller" => "api/postmates", "action" => "receive",
      "postmate" => {
          "status" => "pickup_complete", "kind" => "event.delivery_status", "created" => "2017-12-18T21:06:35Z", "live_mode" => false, "delivery_id" => "del_LYVhhdw8GjKOr-", "data" => {
              "status" => "pickup_complete", "dropoff" => {
                  "phone_number" => "+19174544874", "name" => "About the Stitch", "notes" => "Unit: #710", "detailed_address" => {
                      "city" => "New York", "country" => "US", "street_address_1" => "325 West 38th Street", "street_address_2" => "", "state" => "NY", "sublocality_level_1" => nil, "zip_code" => "10018"
                  }, "location" => {
                      "lat" => 40.75542009999999, "lng" => -73.9927316
                  }, "address" => "325 West 38th Street"
              }, "updated" => "2017-12-18T21:06:35Z", "fee" => 946, "quote_id" => "dqt_LYVhh_EtvJ6btk", "complete" => false, "courier" => {
                  "phone_number" => "", "rating" => "5.0", "name" => "Ninetales R.", "img_href" => "https://d2abve4vv95fsr.cloudfront.net/rGhcwaUFkqzeiQyP1_npIbcdGcg=/288x288/smart/com.postmates.img.prod.s3.amazonaws.com/e1013253-604b-44a9-b531-40e695371840/orig.jpg", "location" => {
                      "lat" => 40.768397942097984, "lng" => -73.94880942725423
                  }, "vehicle_type" => "van"
              }, "created" => "2017-12-18T21:05:58Z", "tip" => nil, "kind" => "delivery", "manifest" => {
                  "description" => "If you have problems with the delivery and cannot reach anyone at the pickup or dropoff phone, please call Brian at (616) 780-4457"
              }, "currency" => "usd", "pickup" => {
                  "phone_number" => "+12122554848", "name" => "J.Crew - 5th Ave", "notes" => "", "detailed_address" => {
                      "city" => "New York", "country" => "US", "street_address_1" => "91 5th Avenue", "street_address_2" => "", "state" => "NY", "sublocality_level_1" => nil, "zip_code" => "10003"
                  }, "location" => {
                      "lat" => 40.737633, "lng" => -73.9922022
                  }, "address" => "91 5th Avenue"
              }, "dropoff_identifier" => "", "live_mode" => false, "dropoff_deadline" => "2017-12-18T21:45:58Z", "related_deliveries" => [], "pickup_eta" => nil, "dropoff_eta" => nil, "id" => "del_LYVhhdw8GjKOr-"
          }, "id" => "evt_LYVhqo5H_3GOxF"
      }
  }
  end
end
