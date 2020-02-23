import UIKit

class TermsAndConditionsViewController: UIViewController {
    
    private var motoIconImageView: UIImageView!
    private var titleLabel: UILabel!
    private var descriptionText: UITextView!
    private var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = def_termsAndConditionsVCBackgroundColor
        setupEssentials()
        setupTitleLabel()
        setupStartButton()
        setupDescriptionText()
    }
    
    fileprivate func setupEssentials() {
        motoIconImageView = UIImageView()
        motoIconImageView.image = def_termsAndConditionsVCImage
        motoIconImageView.contentMode = .scaleAspectFit
        motoIconImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(motoIconImageView)
        motoIconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -def_termsAndConditionsVCImageOffset).isActive = true
        motoIconImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        motoIconImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        motoIconImageView.heightAnchor.constraint(equalToConstant: def_termsAndConditionsVCImageHeight).isActive = true
    }
    
    fileprivate func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: def_termsAndConditionsVCTitleLabelFontSize, weight: .regular)
        titleLabel.textColor = def_termsAndConditionsVCTitleLabelFontColor
        titleLabel.text = NSLocalizedString("welcomeText", comment: "")
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: def_termsAndConditionsVCTitleLabelOffset).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: def_termsAndConditionsVCViewWidth).isActive = true
    }
    
    fileprivate func setupStartButton() {
        startButton = UIButton()
        startButton.setBackgroundImage(def_termsAndConditionsVCStartButton, for: .normal)
        startButton.contentMode = .scaleAspectFit
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: def_termsAndConditionsVCStartButtonFontSize, weight: .regular)
        startButton.setTitleColor(def_termsAndConditionsVCStartButtonFontColor, for: .normal)
        startButton.setTitle("START", for: .normal)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startButton)
        startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -def_termsAndConditionsVCStartButtonOffset).isActive = true
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.widthAnchor.constraint(equalToConstant: def_termsAndConditionsVCViewWidth).isActive = true
        startButton.heightAnchor.constraint(equalToConstant: def_termsAndConditionsVCStartButtonHeight).isActive = true
    }
    
    fileprivate func setupDescriptionText() {
        descriptionText = UITextView()
        descriptionText.text = NSLocalizedString("termsAndConditionsText", comment: "")
        descriptionText.font = UIFont.systemFont(ofSize: def_termsAndConditionsVCDescriptionTextFontSize, weight: .regular)
        descriptionText.textColor = def_termsAndConditionsVCDescriptionTextFontColor
        descriptionText.backgroundColor = def_termsAndConditionsVCBackgroundColor
        descriptionText.textAlignment = .justified
        descriptionText.isScrollEnabled = false
        descriptionText.isEditable = false
        view.addSubview(descriptionText)
        descriptionText.translatesAutoresizingMaskIntoConstraints = false
        descriptionText.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -def_termsAndConditionsVCDescriptionTextOffset).isActive = true
        descriptionText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionText.heightAnchor.constraint(equalToConstant: def_termsAndConditionsVCDescriptionTextMinHeight).isActive = true
        descriptionText.widthAnchor.constraint(equalToConstant: def_termsAndConditionsVCViewWidth).isActive = true
        descriptionText.delegate = self
        
        if let stringText = descriptionText.text as NSString?, let text = descriptionText.attributedText.mutableCopy() as? NSMutableAttributedString {
            text.addAttribute(NSAttributedString.Key.link, value: NSLocalizedString("termsOfServiceUrl", comment: ""), range: stringText.range(of: NSLocalizedString("termsOfServiceKeyword", comment: "")))
            descriptionText.attributedText = text
            
            text.addAttribute(NSAttributedString.Key.link, value: NSLocalizedString("privacyPolicyUrl", comment: ""), range: stringText.range(of: NSLocalizedString("privacyPolicyKeyword", comment: "")))
            descriptionText.attributedText = text
            
            text.addAttribute(NSAttributedString.Key.link, value: NSLocalizedString("disclaimerUrl", comment: ""), range: stringText.range(of: NSLocalizedString("disclaimerKeyword", comment: "")))
            descriptionText.attributedText = text
            
            text.addAttribute(NSAttributedString.Key.link, value: NSLocalizedString("supportUrl", comment: ""), range: stringText.range(of: NSLocalizedString("supportKeyword", comment: "")))
            descriptionText.attributedText = text
        }
        else {
            let errorTitle = NSLocalizedString("termsAndConditionsParsingErrorTitle", comment: "")
            let errorMessage = NSLocalizedString("termsAndConditionsParsingErrorMessage", comment: "")
            
            DispatchQueue.main.async {
                let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        
        let estimatedSize = descriptionText.sizeThatFits(CGSize(width: def_termsAndConditionsVCViewWidth, height: .infinity))
        descriptionText.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
    
    @objc func startButtonTapped(sender: UIButton!) {
        UserDefaults.standard.set(true, forKey: "termsAccepted")
        self.present(MainTabBarController(), animated: true, completion: nil)
    }
}

extension TermsAndConditionsViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if url == URL(string: NSLocalizedString("supportUrl", comment: "")) {
            UIApplication.shared.open(url)
        }
        else {
            let vc = TermsAndConditionsWebViewController()
            vc.url = url
            self.present(vc, animated: true, completion: nil)
        }
        return false
    }
}
