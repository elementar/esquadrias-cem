class Time
  def to_datetime
    # Convert seconds + microseconds into a fractional number of seconds
    seconds = sec + Rational(usec, 10**6)

    # Convert a UTC offset measured in minutes to one measured in a
    # fraction of a day.
    offset = Rational(utc_offset, 60 * 60 * 24)
    DateTime.new(year, month, day, hour, min, seconds, offset)
  end
end

module Builder
  class XmlMarkup
    def dump_hash!(hash, keys)
      keys.each do |hash_key, tag|
        v = db_val(hash, hash_key)
        self.tag!(tag, v) unless v.nil?
      end
      self
    end

    private

    def db_val(db_obj, sym)
      v = db_obj[sym]
      case v
        when Time then
          v.to_datetime
        when 'F' then
          false
        when 'T' then
          true
        else
          v
      end
    end
  end
end
