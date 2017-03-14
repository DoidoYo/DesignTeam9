//
//  TacPacServer.swift
//  TacPac
//
//  Created by Gabriel Fernandes on 2/22/17.
//  Copyright © 2017 Gabriel Fernandes. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class TacPacServer: NSObject {
    
    static var token: String?
    
    static var urlBase: String = "http://custom-env.fz4bnsa2mh.us-west-2.elasticbeanstalk.com/";
    
    static func login(username: String, password: String, completionHandler: @escaping (String?)->Void) {
        var request = URLRequest(url: URL(string: urlBase + "/token")!)
        request.httpMethod = "POST"
        let postString = "grant_type=password&username=\(username)&password=\(password)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print(error)
                completionHandler(error as! String?)
                
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse {
                if httpStatus.statusCode != 200 {
                    var Emsg:String?
                    
                    if httpStatus.statusCode == 400 {
                        Emsg = "Invalid username or password!"
                    }
                    
                    completionHandler(Emsg)
                } else if httpStatus.statusCode == 200{
                    
                    do{
                        let json = try JSONSerialization.jsonObject(with: data) as! [String:AnyObject]
                        
                        let token = json["access_token"] as! String
                        
                        self.token = token
                        
                        //save token
                        KeychainWrapper.standard.set(self.token!, forKey: "token")
                        
                        completionHandler(nil)
                        
                    } catch{
                        print("Error with Json")
                    }
                }
            }
            
            
            
        }
        task.resume()
    }
    
    static func signup(username: String, password: String, firstName: String, lastName: String, birthday: String, completion: @escaping (_ httpCode: Int, _ msg:String) -> Void) {
        
        var request = URLRequest(url: URL(string: urlBase + "/api/Account/Register")!)
        request.httpMethod = "POST"
        let postString = "Email=\(username)&Password=\(password)&FirstName=\(firstName)&LastName=\(lastName)&Birthday=\(birthday)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                var Emsg = String(data:data, encoding: .utf8)
                
                completion(httpStatus.statusCode, Emsg!)
                
                if httpStatus.statusCode == 400 {
                    Emsg = "Invalid username or password!"
                }
                print(Emsg)
            } else {
                //if everything works
                print("Registration Successful")
                
            }
            
        }
        task.resume()
        
    }
    
    static func uploadMeasurement(_ measurement: TacMeasurement, completion: @escaping(_ code:Int)->Void) {
        POSTrequest(place: "api/Tacpac/addMeasurement", body: measurement.toJSON()!, completion: {
            httpCode, data in
            
            ///TODO ERROR DETECTION
            completion(httpCode)
        })
    }
    
    static func getMeasurements(amount: Int, completion: @escaping (_ measurements: [TacMeasurement]?, _ error: String?) -> Void ) {
        POSTrequest(place: "api/Tacpac/getPastMeasurement", body: "\(amount)", completion: {
            httpCode, data in
          
//            print(String(data:data, encoding: .utf8))
            
            if httpCode == 200 {
                do{
                    var mArray = [TacMeasurement]()
                    
                    let json = try JSONSerialization.jsonObject(with: data) as! [AnyObject]
                    
                    for item in json {
                        let concentration = item["concentration"] as! Double
                        let time = item["time"] as! String
                        
                        mArray.append(TacMeasurement(concentration: concentration, time: time))
                    }
                    
                    completion(mArray, nil)
                    
                } catch{
                    completion(nil, "Error with Json")
                }
            } else {
                completion(nil, String(data:data, encoding: .utf8))
            }
            
        })
    }
    
    static func POSTrequest(place:String, body: String, completion: @escaping (_ httpCode: Int, _ data:Data) -> Void) {
        var request = URLRequest(url: URL(string: urlBase + place)!)
        request.httpMethod = "POST"
        
        request.addValue("Bearer \(self.token!)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = body.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print(error)
                
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse {
                do {
                    //print(data)
                    completion(httpStatus.statusCode, data)
                } catch {
                    print("Error with Json")
                    completion(httpStatus.statusCode, data)
                }
            }
            
        }
        task.resume()
    }
    
}

