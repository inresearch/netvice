module Netvice
  module Timestampable
    attr_reader :created_at, :updated_at

    def created_at=(stamp)
      @created_at = convert_from_timestamp(stamp)
    end

    def updated_at=(stamp)
      @updated_at = convert_from_timestamp(stamp)
    end

    private

    def convert_from_timestamp(stamp)
      DateTime.strptime(stamp.to_s, "%s").to_time
    end
  end
end
