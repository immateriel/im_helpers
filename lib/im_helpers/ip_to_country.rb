# -*- encoding : utf-8 -*-
# Country detection from IP address
# http://software77.net/geo-ip/
module ImHelpers
module IpToCountry
    @default_dir="/tmp"
    def self.default_dir
      @default_dir
    end

    def self.default_dir=v
      @default_dir=v
    end

    def self.get(ip)
      unless File.exist?("#{self.default_dir}/IpToCountry.csv")
        self.download
      end
      unless File.exist?("#{self.default_dir}/packed-ip.dat")
        self.packing
      end
      self.search(ip)
    end

    def self.download
      system("wget -q software77.net/geo-ip/?DL=1 -O #{self.default_dir}/IpToCountry.csv.tmp.gz")
      system("gunzip #{self.default_dir}/IpToCountry.csv.tmp.gz")
      system("mv #{self.default_dir}/IpToCountry.csv.tmp #{self.default_dir}/IpToCountry.csv")
    end

    def self.update
      self.download
      self.packing
    end

    def self.packing
      last_start=nil
      last_end=nil
      last_country=nil
      File.open("#{self.default_dir}/packed-ip.dat","wb") do |wfile|
        IO.foreach("#{self.default_dir}/IpToCountry.csv", :encoding => "ISO-8859-1") do |line|
          next if !(line =~ /^"/ )
          s,e,d1,d2,co=line.delete!("\"").split(",")
          s,e = s.to_i,e.to_i
          if !last_start
            # initialize with first entry
            last_start,last_end,last_country = s,e,co
          else
            if s==last_end+1 and co==last_country
              # squeeze if successive ranges have zero gap
              last_end=e
            else
              # append last entry, remember new one
              wfile << [last_start,last_end,last_country].pack("NNa2")
              last_start,last_end,last_country = s,e,co
            end
          end
        end
        # print last entry
        if last_start
          wfile << [last_start,last_end,last_country].pack("NNa2")
        end
      end
    end

    def self.search(ip)
      # the binary table file is looked up with each request
      File.open("#{self.default_dir}/packed-ip.dat","rb") do |rfile|
        rfile.seek(0,IO::SEEK_END)
        record_max=rfile.pos/10-1
        ipstr= ip.split(".").map {|x| x.to_i.chr}.join
        low,high=0,record_max
        while true
          mid=(low+high)/2       # binary search median
          rfile.seek(10*mid)     # one record is 10 byte, seek to position
          str=rfile.read(8)      # for range matching, we need only 8 bytes
          # at comparison, values are big endian, i.e. packed("N")
          if ipstr>=str[0,4]     # is this IP not below the current range?
            if ipstr<=str[4,4]   # is this IP not above the current range?
              return rfile.read(2) # a perfect match, voila!
              break
            else
              low=mid+1          # binary search: raise lower limit
            end
          else
            high=mid-1           # binary search: reduce upper limit
          end
          if low>high            # no entries left? nothing found
            puts "no country"
            return nil
            break
          end
        end
      end
    end

end
end

