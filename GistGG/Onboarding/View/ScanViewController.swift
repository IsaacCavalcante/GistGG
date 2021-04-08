//
//  ViewController.swift
//  GistGG
//
//  Created by Isaac Cavalcante on 31/03/21.
//

import UIKit
import AVFoundation
import QRCodeReader
import FirebaseAuth

class ScanViewController: UIViewController {
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
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
        
        //Configure Navigation bar design
        navigationItem.hidesBackButton = true
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addAndShow(readerVC)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segue.scanToGistSegue{
            if let url = sender as? String{
                let gistViewController = segue.destination as! GistViewController
                gistViewController.gistUrl = url
            }
        }
    }
    
    @IBAction func sigOutTapped(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popViewController(animated: true)
        } catch {
            print("error to sign out")
        }
    }
    
}



//MARK: - QRCodeReaderViewControllerDelegate
extension ScanViewController: QRCodeReaderViewControllerDelegate {
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: K.Segue.scanToGistSegue, sender: result.value)
    }

    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
}

