import UIKit
import AVKit
import Vision

class DetectViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private var noPermissionView: UIView!
    private var noPermissionLabel: UILabel!
    private var noPermissionButton: UIButton!
    private var detectButtonBottom: UIButton!
    private var detectButtonTop: UIButton!
    private let detectorQueue = DispatchQueue(label: "detectorQueue")
    private let captureSession = AVCaptureSession()
    var probabilityList = [String]()
    var previewSubLayer = AVCaptureVideoPreviewLayer()
    private var motoDB: MotoDB?
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = def_detectVCBackgroundColor
        setupDatabase()
        detectorQueue.async { [unowned self] in
            self.checkAndEnableCameraSession()
            self.captureSession.startRunning()
        }
    }
    
    fileprivate func checkAndEnableCameraSession() {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            self.configureSession()
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    self.configureSession()
                } else {
                    DispatchQueue.main.async {
                        self.setupNoPermissionView()
                    }
                }
            })
        }
    }
    
    fileprivate func setupNoPermissionView() {
        setupNoPermissionLabel()
        setupNoPermissionButton()
    }
    
    fileprivate func setupNoPermissionLabel() {
        noPermissionView = UIView()
        noPermissionView.frame = view.frame
        noPermissionView.backgroundColor = def_motorcycleVCBackgroundColor
        view.addSubview(noPermissionView)
        
        noPermissionLabel = UILabel()
        noPermissionLabel.font = UIFont.systemFont(ofSize: def_detectVCNoPermissionLabelFontSize, weight: .regular)
        noPermissionLabel.textColor = def_detectVCNoPermissionLabelFontColor
        noPermissionLabel.text = NSLocalizedString("detectPermissionLabel", comment: "")
        noPermissionLabel.textAlignment = .center
        noPermissionLabel.lineBreakMode = .byWordWrapping
        noPermissionLabel.numberOfLines = 0
        noPermissionLabel.translatesAutoresizingMaskIntoConstraints = false
        noPermissionView.addSubview(noPermissionLabel)
        noPermissionLabel.leftAnchor.constraint(equalTo: noPermissionView.leftAnchor, constant: def_detectVCNoPermissionLabelPaddingLR).isActive = true
        noPermissionLabel.rightAnchor.constraint(equalTo: noPermissionView.rightAnchor, constant: -def_detectVCNoPermissionLabelPaddingLR).isActive = true
        noPermissionLabel.bottomAnchor.constraint(equalTo: noPermissionView.safeAreaLayoutGuide.centerYAnchor, constant: -def_detectVCNoPermissionLabelOffset).isActive = true
    }
    
    fileprivate func setupNoPermissionButton() {
        noPermissionButton = UIButton()
        noPermissionButton.setBackgroundImage(def_detectVCNoPermissionButton, for: .normal)
        noPermissionButton.contentMode = .scaleAspectFit
        noPermissionButton.titleLabel?.font = UIFont.systemFont(ofSize: def_detectVCNoPermissionButtonFontSize, weight: .regular)
        noPermissionButton.setTitleColor(def_detectVCNoPermissionButtonFontColor, for: .normal)
        noPermissionButton.setTitle(NSLocalizedString("detectPermissionButton", comment: ""), for: .normal)
        noPermissionButton.addTarget(self, action: #selector(noPermissionButtonTapped), for: .touchUpInside)
        noPermissionButton.translatesAutoresizingMaskIntoConstraints = false
        noPermissionView.addSubview(noPermissionButton)
        noPermissionButton.topAnchor.constraint(equalTo: noPermissionView.safeAreaLayoutGuide.centerYAnchor, constant: def_detectVCNoPermissionButtonOffset).isActive = true
        noPermissionButton.centerXAnchor.constraint(equalTo: noPermissionView.centerXAnchor).isActive = true
        noPermissionButton.widthAnchor.constraint(equalToConstant: def_detectVCNoPermissionButtonWidth).isActive = true
        noPermissionButton.heightAnchor.constraint(equalToConstant: def_detectVCNoPermissionButtonHeight).isActive = true
    }
    
    @objc func noPermissionButtonTapped(sender: UIButton!) {
        if let url = URL(string:UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        detectorQueue.async { [unowned self] in
            self.captureSession.stopRunning()
            self.previewSubLayer.removeFromSuperlayer()
            DispatchQueue.main.async {
                if self.detectButtonTop != nil {
                    self.detectButtonTop.removeFromSuperview()
                }
                if self.detectButtonBottom != nil {
                    self.detectButtonBottom.removeFromSuperview()
                }
            }
        }
    }
    
    fileprivate func setupDatabase() {
        motoDB = MotoDB { error in
            if error != nil {
                DispatchQueue.main.async {
                    self.showAlert()
                }
            }
        }
    }
    
    fileprivate func setupUIButtons() {
        self.detectButtonBottom = UIButton(type: .system)
        self.detectButtonBottom.setBackgroundImage(def_detectVCButtonImage, for: .normal)
        self.detectButtonBottom.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        self.detectButtonBottom.setTitleColor(UIColor.white, for: .normal)
        
        self.detectButtonTop = UIButton(type: .system)
        self.detectButtonTop.setBackgroundImage(def_detectVCButtonImage, for: .normal)
        self.detectButtonTop.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        self.detectButtonTop.setTitleColor(UIColor.white, for: .normal)
        
        self.view.addSubview(self.detectButtonBottom)
        self.view.addSubview(self.detectButtonTop)
        
        self.detectButtonBottom.translatesAutoresizingMaskIntoConstraints = false
        self.detectButtonBottom.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.detectButtonBottom.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -def_detectVCButtonBottomMargin).isActive = true
        self.detectButtonBottom.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor, constant: def_detectVCButtonLeadingAndTrailingMargin).isActive = true
        self.detectButtonBottom.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor, constant: -def_detectVCButtonLeadingAndTrailingMargin).isActive = true
        self.detectButtonBottom.heightAnchor.constraint(equalToConstant: def_detectVCButtonHeight).isActive = true
        
        self.detectButtonTop.translatesAutoresizingMaskIntoConstraints = false
        self.detectButtonTop.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.detectButtonTop.bottomAnchor.constraint(equalTo: self.detectButtonBottom.topAnchor, constant: -def_detectVCButtonInbetweenMargin).isActive = true
        self.detectButtonTop.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor, constant: def_detectVCButtonLeadingAndTrailingMargin).isActive = true
        self.detectButtonTop.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor, constant: -def_detectVCButtonLeadingAndTrailingMargin).isActive = true
        self.detectButtonTop.heightAnchor.constraint(equalToConstant: def_detectVCButtonHeight).isActive = true
        
        self.detectButtonTop.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        self.detectButtonBottom.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        
        self.detectButtonBottom.isHidden = true
        self.detectButtonTop.isHidden = true
    }
    
    fileprivate func configureSession() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let captureInput = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        if self.captureSession.inputs.count == 0 {
            self.captureSession.addInput(captureInput)
        }
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        if self.captureSession.outputs.count == 0 {
            self.captureSession.addOutput(dataOutput)
        }
        
        previewSubLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        DispatchQueue.main.async {
            self.previewSubLayer.frame = self.view.frame
            self.view.layer.addSublayer(self.previewSubLayer)
            self.setupUIButtons()
        }
    }
    
    @objc func buttonTapped(sender: UIButton?) {
        guard let tappedButton = sender else { return }
        guard let buttonText = tappedButton.titleLabel?.text else { return }
        guard let motoDB = motoDB else { return }
        
        motoDB.getMotorcycleAdditives(motorcycleName: buttonText) { motorcycles, error in
            if error != nil {
                DispatchQueue.main.async {
                    self.showAlert()
                }
            }
            else {
                guard let motorcycles = motorcycles else { return }
                if motorcycles.count > 1 {
                    let selectResultVC = SelectResultViewController()
                    selectResultVC.additiveMotorcycleIds = motorcycles
                    self.present(selectResultVC, animated: true, completion: nil)
                }
                else {
                    self.motoDB?.getMotorcycleInformation(uniqueMotorcycleName: buttonText, completion: { motorcycleDetails, error in
                        guard let details = motorcycleDetails else { return }
                        let moto = MostRecentMotorcycle(id: details.id, brand: details.brand, model: details.model, modelExtention: nil, year: details.years)
                        MostRecentPersistentData.shared.saveToPersistentData(motorcycle: moto) { error in
                            if error != nil {
                                let alert = UIAlertController(title: NSLocalizedString("persistentDataSavingErrorTitle", comment: ""), message: NSLocalizedString("persistentDataSavingErrorMessage", comment: ""), preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default) { UIAlertAction in
                                    if let tabBarController = self.presentingViewController as? UITabBarController {
                                        tabBarController.selectedIndex = 2
                                        self.dismiss(animated: true, completion: nil)
                                    }
                                })
                                self.present(alert, animated: true)
                            }
                            else {
                                tappedMotorcycleID = moto.id
                                nrOfMostRecentMotorcycles += 1
                                self.tabBarController?.selectedIndex = 2
                            }
                        }
                    })
                }
            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        guard let model = try? VNCoreMLModel(for: ImageClassificationModel().model) else { return }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation] else { return }
            
            let mostProbable = results[0]
            let secondMostProbable = results[1]
            let thirdMostProbable = results[2]
            
            if (mostProbable.confidence > def_detectVCConfidenceThreshhold) {
                if (self.probabilityList.count > def_detectVCProbablilityThreshhold) {
                    self.probabilityList.remove(at: 0)
                }
                
                self.probabilityList.append(mostProbable.identifier)
                
                if (self.probabilityList.allSatisfy { $0 ==  mostProbable.identifier }) {
                    if self.probabilityList.contains(def_detectVCNoMotorcycle) == false {
                        DispatchQueue.main.async {
                            self.detectButtonTop.isHidden = false
                            self.detectButtonTop.setTitle(mostProbable.identifier, for: .normal)
                            
                            self.detectButtonBottom.isHidden = false
                            self.detectButtonBottom.setTitle(secondMostProbable.identifier == def_detectVCNoMotorcycle ? thirdMostProbable.identifier : secondMostProbable.identifier, for: .normal)
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.detectButtonTop.isHidden = true;
                            self.detectButtonTop.setTitle("", for: .normal)
                            self.detectButtonBottom.isHidden = true;
                            self.detectButtonBottom.setTitle("", for: .normal)
                        }
                    }
                }
            }
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
    fileprivate func showAlert() {
        let alert = UIAlertController(title: NSLocalizedString("databaseErrorTitle", comment: ""), message: NSLocalizedString("databaseErrorMessage", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { UIAlertAction in
            tappedMotorcycleID = 0
            if let tabBarController = self.presentingViewController as? UITabBarController {
                tabBarController.selectedIndex = 0
            }
        })
        self.present(alert, animated: true)
    }
}
