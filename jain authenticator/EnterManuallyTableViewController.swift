//
//  EEnterManuallyTableViewController.swift
//  jain authenticator
//
//  Created by Shubham Jain on 11/01/19.
//  Copyright © 2019 Shubham Jain. All rights reserved.
//

import Foundation
import UIKit
import  Base32
import OneTimePassword

protocol  SendDelegateToOtpController {
    func sendData (name: String , mailId: String , otp: String)
}
class EnterManuallyTableViewController : UITableViewController{
    var  delegatee : SendDelegateToOtpController?
   var  name : String = "..."
    var issuer : String = "..."
    var secretString : String = "..."
    
    @IBOutlet var serviceOutlet: UITextField!
    @IBOutlet var accountOutlet: UITextField!
    @IBOutlet var keyOutlet: UITextField!
    @IBAction func saveButtonAction(_ sender: Any) {
        name = serviceOutlet.text!
        issuer = accountOutlet.text!
        secretString = keyOutlet.text!
        
        persistance()
        self.delegatee?.sendData(name: name, mailId: issuer, otp: "1234" )
        self.navigationController?.popViewController(animated: true)
        }
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.navigationItem.title = "Enter Manually"
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Enter Manually"
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = " "
    }
        func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =     UITapGestureRecognizer(target: self, action:    #selector(EnterManuallyTableViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

      func persistance() {
        
        guard let secretData = MF_Base32Codec.data(fromBase32String: self.secretString),
            !secretData.isEmpty else {
                print("Invalid secret")
                return
        }
        guard let generator = Generator(factor: .timer(period: 30),secret: secretData,
                                        algorithm: .sha1,
                                        digits: 6) else {
                                            print("Invalid generator parameters")
                                            return
        }
        let token = Token(name: name, issuer: issuer, generator: generator)
        let password = token.currentPassword
        let timeIntervalToday: TimeInterval = Date().timeIntervalSince1970
        
        let time = Date(timeIntervalSince1970: timeIntervalToday)
        do {
            let passwordAtTime = try token.generator.password(at: time)
            print("Password at time: \(passwordAtTime)")
        } catch {
            print("Cannot generate password for invalid time \(time)")
        }
        
        let keychain = Keychain.sharedInstance
        do {
            let persistentToken = try keychain.add(token)
            print("Saved to keychain with identifier: \(persistentToken.identifier)")
        } catch {
            print("Keychain error: \(error)")
        }
       // To retrieve a token from the keychain:
//            do {
//                if let persistentToken = try keychain.persistentToken(withIdentifier: ) {
//                    print("Retrieved token: \(persistentToken.token)")
//                }
//                // Or...
//                let persistentTokens = try keychain.allPersistentTokens()
//                print("All tokens: \(persistentTokens.map({ $0.token }))")
//        } catch {
//            print("Keychain error: \(error)")
//        }
//       // To update a saved token in the keychain:
//            do {
//                let updatedPersistentToken = try keychain.update(persistantToken, with: token)
//                print("Updated token: \(updatedPersistentToken)")
//        } catch {
//            print("Keychain error: \(error)")
//        }
//
////         To delete a token from the keychain:
//
//            do {
//                try keychain.delete(persistentToken)
//                print("Deleted token.")
//          } catch {
//            print("Keychain error: \(error)")
//        }
    }
}
