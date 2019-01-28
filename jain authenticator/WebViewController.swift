//
//  WebViewController.swift
//  jain authenticator
//
//  Created by Shubham Jain on 31/07/18.
//  Copyright © 2018 Shubham Jain. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation

class WebViewController: UIViewController {
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var stringURL: String = " "
    
    enum error : Error {
        case noCameraAvailable
        case videoInputInitFail
    }
    
    @IBOutlet var previewView: UIView!
    static func controller() -> WebViewController {
        
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewVC") as! WebViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.navigationItem.title = "Scan QR"
        
        
        do{
            
            try scanQRCode()
        }
            
        catch{
            print("Failed to scan QR code")
        }
       
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Scan QR"
        super.viewWillAppear(animated)
    
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = " "
    }
    
    
    func scanQRCode() throws{
        let avCaptureSession = AVCaptureSession()
        guard let avCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                print("No camera.")
                throw error.noCameraAvailable
        }
        
        guard let avCaptureInput = try? AVCaptureDeviceInput(device: avCaptureDevice)
            else {
                
                print("Failed to init camera")
                throw error.videoInputInitFail
        }
        
        let avCaptureMetadataOutput = AVCaptureMetadataOutput()
        avCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        avCaptureSession.addInput(avCaptureInput)
        avCaptureSession.addOutput(avCaptureMetadataOutput)
        
        avCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        let avCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session : avCaptureSession)
        avCaptureVideoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avCaptureVideoPreviewLayer.frame = previewView.bounds
        
        self.previewView.layer.addSublayer(avCaptureVideoPreviewLayer)
        avCaptureSession.startRunning()
        

        
    }
    
}
    extension WebViewController : AVCaptureMetadataOutputObjectsDelegate{
        
        
        func captureOutput(_captureOutput : AVCaptureOutput! , didOutputMatadataObjects metadataObjects:[Any]!, from connection : AVCaptureConnection!)  {
            
            let qrCodeFrameView = UIView()
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
            
            
            if metadataObjects.count>0{
                let machineReadableCode = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
                if machineReadableCode.type == AVMetadataObject.ObjectType.qr{
                    let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: machineReadableCode)
                    qrCodeFrameView.frame = barCodeObject!.bounds
                    
                    stringURL = machineReadableCode.stringValue!
                    print(stringURL)
                }
            }
            else {
                qrCodeFrameView.frame = CGRect.zero
                print("No QR code is detected")
            }
        }
        
        
        
        
        
        
        
    }

