//
//  ViewController.swift
//  GistGG
//
//  Created by Isaac Cavalcante on 31/03/21.
//

import UIKit
import AVFoundation
import QRCodeReader

class ViewController: UIViewController {
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            
            // Configure the view controller (optional)
            $0.showTorchButton        = false
            $0.showSwitchCameraButton = true
            $0.showCancelButton       = false
            $0.showOverlayView        = true
            $0.rectOfInterest         = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readerVC.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addChild(self.readerVC)
        self.readerVC.view.frame = self.view.frame
        self.view.addSubview(self.readerVC.view)
        self.readerVC.didMove(toParent: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segue.scanToGistSegue{
            if let url = sender as? String{
                let gistViewController = segue.destination as! GistViewController
                gistViewController.gistUrl = url
            }
        }
    }
}



//MARK: - QRCodeReaderViewControllerDelegate
extension ViewController: QRCodeReaderViewControllerDelegate {
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: K.Segue.scanToGistSegue, sender: result.value)
    }
    
    //This is an optional delegate method, that allows you to be notified when the user switches the cameraName
    //By pressing on the switch camera button
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        print("Switching capture to: \(newCaptureDevice.device.localizedName)")
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
}

