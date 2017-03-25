//
//  TacPacModels.swift
//  TacPac
//
//  Created by Gabriel Fernandes on 3/9/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation

class TacMeasurement : JSONSerializable, Equatable {
    
    var id: Int?
    var concentration:Double
    var time: String
    
    init(concentration: Double, time:String) {
        self.concentration = concentration
        self.time = time
    }
    
    static func ==(lhs: TacMeasurement, rhs: TacMeasurement) -> Bool {
        if let lid = lhs.id, let rid = rhs.id {
            if lid == rid {
               return true
            }
        }
        return false
    }
}


protocol JSONRepresentable {
    var JSONRepresentation: AnyObject { get }
}
protocol JSONSerializable: JSONRepresentable {
}
extension JSONSerializable {
    var JSONRepresentation: AnyObject {
        var representation = [String: AnyObject]()
        
        for case let (label?, value) in Mirror(reflecting: self).children {
            switch value {
            case let value as JSONRepresentable:
                representation[label] = value.JSONRepresentation
                
            case let value as NSObject:
                representation[label] = value
                
            default:
                // Ignore any unserializable properties
                break
            }
        }
        
        return representation as AnyObject
    }
}
extension JSONSerializable {
    func toJSON() -> String? {
        let representation = JSONRepresentation
        
        guard JSONSerialization.isValidJSONObject(representation) else {
            return nil
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: representation, options: [])
            return String(data: data, encoding: String.Encoding.utf8)
        } catch {
            return nil
        }
    }
}
