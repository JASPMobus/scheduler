class Temporal
    #checks that the provided time is acceptable
    def self.acceptable_time?(params, user, appointment = nil)
        time_split = params["time"].split(":")
        date_split = params["date"].split("-")

        #makes sure that the time part is a good format.
        if time_split.length!=2 || time_split[0].length>2 || time_split[1].length!=2 || !are_numeric?(time_split) || time_split[0].to_i > 24 || time_split[1].to_i > 60
            return "incorrect-time-format"

        #makes sure that the date part is a good format
        elsif date_split.length!=3 || !are_numeric?(date_split)
            return "incorrect-date-format"

        #checks if the user or the provider are busy during the appointment.
        else
            datetime = Temporal.generate_datetime(params["date"], params["time"])

            if appointment
                if !user.is_available?(datetime, params["duration"], appointment.id) || !User.find(params["provider_id"]).is_available?(datetime, params["duration"], appointment.id)
                    return "time-unavailable"
                end 
            else
                if !user.is_available?(datetime, params) || !User.find(params["provider_id"]).is_available?(datetime, params["duration"])
                    return "time-unavailable"
                end
            end

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

    #checks if time2 is within duration of time1
    def self.is_during_appointment?(time1, time2, duration)
        start = comparatize(time1.strftime("%k:%M"))
        check = comparatize(time2.strftime("%k:%M"))
        finish = time_after_x_minutes(start, duration)
        midpoint = (start+finish)/2

        start <= check && check < finish
    end

    private

    #turns a time into a decimal
    def self.comparatize(time)
        #time is of form HH:MM, 24 hour clock, no padding on hour
        time_split = time.split(":")

        time_ret = time_split[0].to_f
        minutes = time_split[1].to_f/60

        time_ret + minutes
    end

    #adds x minutes to the given time (previously comparatized)
    def self.time_after_x_minutes(time, x)
        comparatize("#{time}:#{x}")
    end

    #checks if a string is numeric
    def self.is_numeric?(str)
        Float(str) != nil rescue false
    end

    def self.are_numeric?(strs)
        strs.each do |str|
            if !is_numeric?(str)
                return false 
            end 
        end 

        return true
    end
end