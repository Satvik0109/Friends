//
//  Friend.swift
//  Satvik_Friends
//
//  Created by Satvik Kathpal on 2021-11-24.
//  991487352

import Foundation

struct Friend : Codable, Identifiable, Hashable{
    var id : String? = UUID().uuidString
    var name : String = ""
    var city : String = ""
    var country : String = ""
    var phone : Double = 0
    var email : String = ""
    var lat : String = ""
    var lon : String = ""
    var isoCountryCode : String = ""
    
    init() {
        
    }
    
    init(name: String, city: String, country: String, phone: Double, email: String){
        self.name = name
        self.city = city
        self.country = country
        self.phone = phone
        self.email = email
        //do geocoding for lat lon and country code
    }
    
    init(name: String, city: String, country: String, phone: Double, email: String, lat: String, lon: String, isoCountryCode: String){
        self.name = name
        self.city = city
        self.country = country
        self.phone = phone
        self.email = email
        self.lat = lat
        self.lon = lon
        self.isoCountryCode = isoCountryCode
    }
    
    //initializer used to parse JSON objects into Swift objects
    init?(dictionary: [String: Any]){
        guard let name = dictionary["name"] as? String else{
            return nil
        }
        
        guard let city = dictionary["city"] as? String else{
            return nil
        }
        
        guard let country = dictionary["country"] as? String else{
            return nil
        }
        
        guard let phone = dictionary["phone"] as? Double else{
            return nil
        }
        
        guard let email = dictionary["email"] as? String else{
            return nil
        }
        
        guard let lat = dictionary["lat"] as? String else{
            return nil
        }
        
        guard let lon = dictionary["lon"] as? String else{
            return nil
        }
        
        guard let isoCountryCode = dictionary["isoCountryCode"] as? String else{
            return nil
        }
        
        
        self.init(name: name, city: city, country: country, phone: phone, email: email, lat: lat, lon: lon, isoCountryCode: isoCountryCode)
    }
}
