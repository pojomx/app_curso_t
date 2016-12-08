//
//  ViewController.swift
//  afnetworking
//
//  Created by Alan Milke on 12/7/16.
//  Copyright © 2016 espiralapp.com. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tblTabla: UITableView!
    
    var arreglo : [(nombre: String, edad: Int, genero: String, foto: String)] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        sincronizar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sincronizar ()
    {
        let url = URL(string: "http://kke.mx/demo/contactos.php")
        
        var request = URLRequest(url: url!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 1000)
        request.httpMethod = "POST"
        
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            guard (error == nil) else {
                print("Ocurrió un error con la petición: \(error)")
                return
            }
            
           // let das = data?.base64EncodedString()
           // let dat = Data(base64Encoded: "ABABABABABA==")
            
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                print("Ocurrió un error con la respuesta.")
                return
            }
            if (!(statusCode >= 200 && statusCode <= 299))
            {
                print("Respuesta no válida")
                return
            }
            let cad = String(data: data!, encoding: .utf8)
            print("Response: \(response!.description)")
            print("error: \(error)")
            print("data: \(cad!)")
            
            var parsedResult: Any!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            } catch {
                parsedResult = nil
                print("Error: \(error)")
                return
            }
            
            guard let datos = (parsedResult as? Dictionary<String, Any?>)?["datos"]
                as! [Dictionary<String, Any>]! else {
                print("Error: \(error)")
                return
            }
            
            self.arreglo.removeAll()
        
            for d in datos {
                let nombre = (d["nombre"] as! String)
                let edad = (d["edad"] as! Int)
                let foto = d["foto"] as! String
                let genero = d["genero"] as! String
                //  var arreglo : [(nombre: String, edad: Int, genero: String, foto: String)] = []
                self.arreglo.append((nombre: nombre, edad: edad, genero: genero, foto: foto))
                
                
            }
            
            self.tblTabla.reloadData()
            
        })
        
        task.resume()
        
    
    }
    
    //MARK: - Table View Delegates
    
    /*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 100;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let view = tableView.dequeueReusableCell(withIdentifier: "Fila") as! TableViewCell
        
        view.imgFoto.loadPicture(url: "http://kke.mx/demo/img/user_male.png")
        //view.imgFoto.downloadData(url: "http://kke.mx/demo/img/user_male.png")
        
        
        view.lblNombre.text = "Número \(indexPath.row)"
        view.lblEdad.text = "\(indexPath.row)"
        
        return view
    }
    
    */

   //  https://github.com/pojomx/app_curso_t.git 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arreglo.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let view = tableView.dequeueReusableCell(withIdentifier: "Fila") as! TableViewCell
        
        //view.imgFoto.loadPicture(url: "http://kke.mx/demo/img/user_male.png")
        //view.imgFoto.downloadData(url: "http://kke.mx/demo/img/user_male.png")
        
        let dato = arreglo[indexPath.row];
        
        view.lblNombre.text = "\(dato.nombre)"
        view.lblEdad.text = "\(dato.edad)"
        
        if dato.genero == "m" {
            view.imgFoto.image = UIImage(named: "user_female")
        } else {
            view.imgFoto.image = UIImage(named: "user_male")
        }
        
        view.imgFoto.downloadData(url: dato.foto)
        /*
        view.imgFoto.loadPicture(url: dato.foto)
        */
        
        return view
    }
    
}

