class QuickPick < ActiveRecord::Base
    belongs_to :user

    def trains(all_trains)
        if self.direction.nil? && self.rail_line_name.nil?
            all_trains.select{|obj| obj['STATION'] == self.station_name}
        elsif !self.direction.nil? && !self.rail_line_name.nil?
            all_trains.select{|obj| obj['DIRECTION'] == self.direction}.select{|train| train['LINE'] == self.rail_line_name}
        elsif self.direction
            all_trains.select{|obj| obj['DIRECTION'] == self.direction}
        elsif self.rail_line_name
            all_trains.select{|obj| obj['LINE'] == self.rail_line_name}
        end
    end

    def train_direction
        if self.direction.nil?
            "Not Defined"
        else
            self.direction
        end
    end

    def train_line
        if self.rail_line_name.nil?
            "Not Defined"
        else
            self.rail_line_name
        end
    end

    def alias_nil_or_empty_string?
        self.alias.nil? || !!self.alias == ''
    end
end
