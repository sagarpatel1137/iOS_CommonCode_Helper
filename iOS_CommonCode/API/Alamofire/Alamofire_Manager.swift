//
//  Alamofire.swift
//  iOS_CommonCode
//
//  Created by IOS on 15/08/24.
//

import Alamofire

public class Alamofire_Manager
{
    public class func request(url: String, parameter: Parameters?, complition : @escaping (Data?,Error?) -> Void)
    {
        AF.session.configuration.timeoutIntervalForRequest = 30
        AF.request(url, method: .post, parameters: parameter,encoding: JSONEncoding.default, headers: nil)
            .response { response in
                switch (response.result) {
                case .success:
                    if let responseData = response.data{
                        return complition (responseData, nil)
                    }else{
                        complition(nil,response.error)
                    }
                case .failure(let error):
                    complition(nil,error)
                }
            }
    }
    
    
    public class func requestWithImageUpload(url: String, parameter: [String:String], imageParameter: [(String,String,UIImage)], complition : @escaping (Data?,Error?) -> Void)
    {
        AF.session.configuration.timeoutIntervalForRequest = 30
        AF.upload(multipartFormData: { multipartFormData in
            
            for items in imageParameter {
                if let imageData = items.2.jpegData(compressionQuality: 1) {
                    multipartFormData.append(imageData, withName: items.0, fileName: items.1, mimeType: "image/png")
                }
            }
            
            for (key, value) in parameter {
                multipartFormData.append((value.data(using: .utf8))!, withName: key)
            }
            
        }, to: url, method: .post)
        .response { response in
            switch (response.result) {
            case .success:
                if let responseData = response.data{
                    return complition (responseData, nil)
                }else{
                    complition(nil,response.error)
                }
            case .failure(let error):
                complition(nil,error)
            }
        }
    }
}

