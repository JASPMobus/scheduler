class Temporal
    #checks that the provided time is acceptable
    def self.acceptable_time?(time)
        time_split = time.split(":")
        if time_split.length!=2 || time_split[0].length>2 || time_split[1].length!=2 || time_split[0].to_i > 24 || time_split[1].to_i > 60
            return "incorrect-time-format"
        else
            return true
        end
    end

    #takes date and time entries and generates a datetime object
    def self.generate_datetime(date, time)
        #examples of received date and time: date: "2019-12-15" time: "4:00"
        #example of datetime creation DateTime.new(2001,2,3,4,5,6) 
                                      #=> #<DateTime: 2001-02-03T04:05:06+00:00>
        date_info = date.split("-")
        year = date_info[0].to_i
        month = date_info[1].to_i
        day = date_info[2].to_i

        time_info = time.split(":")
        hour = time_info[0].to_i
        minute = time_info[1].to_i

        DateTime.new(year, month, day, hour, minute, 0)
    end
end