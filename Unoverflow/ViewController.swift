//
//  ViewController.swift
//  Unoverflow
//
//  Created by Andres Rene Gutierrez on 21/08/2016.
//  Copyright © 2016 Andres Rene Gutierrez. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailText.placeholder = "Enter your email"
        passwordText.placeholder = "Enter your password"
        passwordText.secureTextEntry = true
        emailText.delegate = self
        passwordText.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        emailText.text = ""
        passwordText.text = ""
        
    }
   

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUp(sender: AnyObject) {
        let url = NSURL(string: "https://unoverflow.herokuapp.com/sign_up")
        let safariController = SFSafariViewController(URL: url!)
        presentViewController(safariController, animated: true, completion: nil)
    }

    @IBAction func logIn(sender: AnyObject) {
        let email = emailText.text!
        let password = passwordText.text!
        if email == "" || password == "" {
            self.presentViewController(Utilities.alertMessage("Error", message: "All the fields are required"), animated: true, completion: nil)
        }else{
            let URL = "http://unoverflow.herokuapp.com/api/v1/users/login"
            let request = NSMutableURLRequest(URL: NSURL(string: URL)!,cachePolicy: .UseProtocolCachePolicy,timeoutInterval: 10.0)
            let session = NSURLSession.sharedSession()
            request.HTTPMethod = "POST"
            let params = ["email":email,"user_password":password]
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(params, options: .PrettyPrinted)
            request.addValue("application/json", forHTTPHeaderField: "Content-type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            let task = session.dataTaskWithRequest(request,completionHandler: {data,response, error-> Void in
                
                if let httpResponse = response as? NSHTTPURLResponse {
                    let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                    if httpResponse.statusCode == 200 {
                        NSOperationQueue.mainQueue().addOperationWithBlock({() -> Void in
                            let user = Utilities.parseJSONToUser(json)
                            Utilities.user =  user
                            
                            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("profile")
                            self.presentViewController(viewController, animated: true, completion: nil)
                        })
                        
                        
                    }else{
                        let message = json["errors"] as! String
                        NSOperationQueue.mainQueue().addOperationWithBlock({() -> Void in
                            self.presentViewController(Utilities.alertMessage("Error", message: message), animated: true, completion: nil)
                        })
                    }
                }
                
            })
            task.resume()
            
        }
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    

}

