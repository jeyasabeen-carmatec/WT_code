//
//  VC_srch_Course.swift
//  WinningTicket
//
//  Created by Test User on 26/07/17.
//  Copyright © 2017 Test User. All rights reserved.
//

import UIKit

var ARR_states : NSArray = NSArray()
var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
var VW_overlay: UIView = UIView()

class VC_srch_Course: UIViewController {

    @IBOutlet weak var TBL_states :UITableView!
    @IBOutlet weak var TBL_coursename :UITableView!
    @IBOutlet weak var TXT_states :UITextField!
    @IBOutlet weak var TXT_coursename :UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        TXT_states.addTarget(self, action: Selector(("states_val_changed:")), for: UIControlEvents.allEditingEvents)
//        TXT_states.addTarget(self, action:Selector(("states_val_changed:")), for:.editingChanged);
        
//        TXT_coursename.addTarget(self, action: #selector(textChanged), for: .valueChanged)
        
        TXT_coursename.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
        
        TXT_states.addTarget(self, action: #selector(self.states_val_changed), for: .editingChanged)

        
        TBL_states.isHidden = true
        TBL_coursename.isHidden = true
        
        
        VW_overlay = UIView(frame: UIScreen.main.bounds)
        VW_overlay.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicatorView.frame = CGRect(x: 0, y: 0, width: activityIndicatorView.bounds.size.width, height: activityIndicatorView.bounds.size.height)
        
        activityIndicatorView.center = VW_overlay.center
        VW_overlay.addSubview(activityIndicatorView)
        VW_overlay.center = view.center
        view.addSubview(VW_overlay)
        
        activityIndicatorView.startAnimating()
        perform(#selector(self.Places_API), with: activityIndicatorView, afterDelay: 0.01)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

    
    @IBAction func button_back(sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func states_val_changed(){
        print("Text changed: " + TXT_states.text!)
    }
    
    
    func textChanged(){
        print("Text changed: " + TXT_coursename.text!)
    }
    
    func Places_API()
    {
        let STR_url = String(format: "%@golfcourse/search_by_location", SERVER_URL)
        let auth_tok = String(format:"%@",UserDefaults.standard.value(forKey:"auth_token") as! CVarArg)
           if let url = NSURL(string:STR_url) {
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue(auth_tok, forHTTPHeaderField: "auth_token")
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
            
                activityIndicatorView.stopAnimating()
                VW_overlay.isHidden = true
//                VW_overlay.removeFromSuperview()
                
                if error != nil {
                    print("\(String(describing: error))")
                    activityIndicatorView.stopAnimating()
                    VW_overlay.isHidden = true
                    return
                }
                
                
//                var error:NSError? = nil
                
//                let temp_dictin: [AnyHashable: Any]? = ((try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [AnyHashable: Any])
                
//                let jsonData = Data()
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions(rawValue: 0))
                    guard let dictionary = jsonObject as? Dictionary<String, Any> else {
                        print("Not a Dictionary")
                        // put in function
                        activityIndicatorView.stopAnimating()
                        VW_overlay.isHidden = true
                        return
                    }
//                    print("JSON Dictionary! \(dictionary)")
                    

                    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                        activityIndicatorView.stopAnimating()
                        VW_overlay.isHidden = true
                        ARR_states = dictionary["course_locations"] as! NSArray
                        NSLog("States response %@", ARR_states)
                    }
                    
                    
                }
                catch let error as NSError {
                    
                    activityIndicatorView.stopAnimating()
                    VW_overlay.isHidden = true
                    
                    print("Found an error - \(error)")
                }
                
                
                
                
                
            }
//            activityIndicatorView.stopAnimating()
//            VW_overlay.isHidden = true
            task.resume()
        }
    }
}
