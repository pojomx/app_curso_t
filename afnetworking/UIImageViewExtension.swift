//
//  UIImageViewExtension.swift
//  afnetworking
//
//  Created by Alan Milke on 12/7/16.
//  Copyright © 2016 espiralapp.com. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func loadPicture(url : String)
    {
        if url.characters.count < 7 {
            return
        }
        
        let dato : Data?
        
        do {
            dato = try Data(contentsOf: URL(string: url)!)
        } catch {
            dato = nil
            print("Error: \(error)")
            return
        }
        
        self.image = UIImage(data: dato!)
    
    }
    
    func downloadData(url: String) {
        
        var request = URLRequest(url: URL(string: url)!,
                        cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad,
                        timeoutInterval: 1000)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            
            guard (error == nil) else {
                print("Ocurrió un error con la petición: \(error)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                
                print("Ocurrió un error con la respuesta.")
                return
            }
            
            if (!(statusCode >= 200 && statusCode <= 299))
            {
                print("Respuesta no válida")
                return
            }
            
            
            print("Response: \(response!.description)")
            print("error: \(error)")
            
            self.image = UIImage.init(data: data!)
            
        })
        
        task.resume()
        
    }

    
}
