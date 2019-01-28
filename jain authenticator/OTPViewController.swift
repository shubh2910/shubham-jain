////
////  OTPViewController.swift
////  jain authenticator
////
////  Created by Shubham Jain on 30/07/18.
////  Copyright © 2018 Shubham Jain. All rights reserved.
////
//
import UIKit
import AVFoundation

struct otpData{
    var name:String
    var emailId:String
    var otpCode:String
}

class OTPViewController: UIViewController , UITableViewDataSource , UITableViewDelegate , AVCaptureMetadataOutputObjectsDelegate ,SendDelegateToOtpController {
    
    @IBOutlet var typeButtonOutlet: UIButton!
    @IBOutlet var scanButtonOutlet: UIButton!
    var timer: Timer!
    var progressCounter:Float = 0
    let duration:Float = 30.0
    var progressIncrement:Float = 0
    @IBOutlet var addButtonOutlet: UIButton!
    @IBOutlet var addButtonImageOutlet: UIImageView!
    var flag : Bool = false
    
    @IBOutlet var scancodeOutlet: UILabel!
    @IBOutlet var enterManuallyOutlet: UILabel!
    @IBOutlet var cameraImage: UIImageView!
    @IBOutlet var keyboardImage: UIImageView!
    
    @IBAction func typeAction(_ sender: UIButton) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EnterManuallyVC") as! EnterManuallyTableViewController
        controller.delegatee = self
        self.navigationController?.pushViewController(controller , animated: true)
        UnPressed()
    }
    
    @IBAction func scanAction(_ sender: Any) {
        self.navigationController?.pushViewController(WebViewController.controller(), animated: true)
        UnPressed()
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        if(flag == false){pressed()}
        else{UnPressed()}
    }
    @IBOutlet var otpTableOutlet: UITableView!
    @IBOutlet var videoPreview : UIView!
    var stringURL = String()
    var otpList:[otpData] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.title = "Authenticator"
        cameraImage.isHidden = true
        keyboardImage.isHidden = true
        scancodeOutlet.isHidden = true
        enterManuallyOutlet.isHidden = true
        scanButtonOutlet.isEnabled = false
        typeButtonOutlet.isEnabled = false
        progressIncrement = 1.0/duration
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.showProgress), userInfo: nil, repeats: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Authenticator"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        otpTableOutlet.reloadData()

    }
    override func viewDidAppear(_ animated: Bool) {
        otpTableOutlet.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = ""
           otpTableOutlet.reloadData()
    }
    @objc func showProgress() {
        DispatchQueue.main.async {
            if(self.progressCounter > 1.0){self.timer.invalidate()
                self.progressCounter = 0.0
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.showProgress), userInfo: nil, repeats: true)
            }
            self.progressCounter = self.progressCounter + self.progressIncrement
        }

    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if (otpList.count == 0){return 2}
            else {return otpList.count}
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(otpList.count==0){
            switch indexPath.row{
            case 0 :
            let cell = otpTableOutlet.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
            cell.configure(isEmpty: true, otpData(name: "", emailId: "", otpCode: ""))
            cell.propgressBarOutlet.isHidden = true
            return cell

            default:
                let cell = otpTableOutlet.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath)as! TableImageViewCell
                return cell
            }
        } else {
            let cell = otpTableOutlet.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
             cell.configure(isEmpty: false, otpList[indexPath.row])
             cell.propgressBarOutlet.isHidden = false
             cell.propgressBarOutlet.progress = self.progressCounter
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(otpList.count == 0 ){
            switch indexPath.row{
            case 0 : return 160
            default : return 388
                }
        }
        else {return 120}
    }
    
    func pressed(){
        cameraImage.isHidden = false
        keyboardImage.isHidden = false
        scancodeOutlet.isHidden = false
        enterManuallyOutlet.isHidden = false
        addButtonImageOutlet.image = UIImage(named: "cross")
        addButtonImageOutlet.contentMode = .scaleAspectFill
        flag = true
        scanButtonOutlet.isEnabled = true
        typeButtonOutlet.isEnabled = true
    }
    func UnPressed(){
        cameraImage.isHidden = true
        keyboardImage.isHidden = true
        scancodeOutlet.isHidden = true
        enterManuallyOutlet.isHidden = true
        addButtonImageOutlet.image = UIImage(named: "add")
        flag = false
        scanButtonOutlet.isEnabled = false
        typeButtonOutlet.isEnabled = false
    }
    func sendData(name: String, mailId: String, otp: String) {
        otpList.append(otpData(name: name, emailId: mailId, otpCode: otp))
    }
}

