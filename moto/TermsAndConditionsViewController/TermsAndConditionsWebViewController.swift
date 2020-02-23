import UIKit
import WebKit

class TermsAndConditionsWebViewController: UIViewController, WKNavigationDelegate {

    private var closeButton: UIButton!
    private var closeImage: UIImageView!
    private var searchCellSeperator: UIImageView!
    private var webView: WKWebView!
    private var activityIndicator: UIActivityIndicatorView!
    private var timeOut: Timer!
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = def_termsAndConditionsVCBackgroundColor
        setupCloseButton()
        createCellSeperator()
        setupWebView()
        setupActivityIndicator()
        fetchWebData()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
        timeOut = Timer.scheduledTimer(timeInterval: def_termsAndConditionsVCRequestTimeout, target: self, selector: #selector(cancelWebView), userInfo: nil, repeats: false)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        timeOut.invalidate()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        timeOut.invalidate()
    }
    
    @objc func cancelWebView() {
        showAlert()
    }
    
    fileprivate func setupCloseButton() {
        closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: def_termsAndConditionsVCCloseButtonPaddingTop).isActive = true
        closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: def_termsAndConditionsVCCloseButtonPaddingLeft).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: def_termsAndConditionsVCCloseButtonWidthHeight).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: def_termsAndConditionsVCCloseButtonWidthHeight).isActive = true
        
        closeImage = UIImageView()
        closeImage.image = def_termsAndConditionsVCCloseIcon
        closeImage.contentMode = .scaleAspectFit
        closeImage.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addSubview(closeImage)
        closeImage.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: def_termsAndConditionsVCCloseIconPaddingTop).isActive = true
        closeImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: def_termsAndConditionsVCCloseIconPaddingLeft).isActive = true
        closeImage.widthAnchor.constraint(equalToConstant: def_termsAndConditionsVCCloseIconWidthHeight).isActive = true
        closeImage.heightAnchor.constraint(equalToConstant: def_termsAndConditionsVCCloseIconWidthHeight).isActive = true
    }
    
    fileprivate func createCellSeperator() {
        searchCellSeperator = UIImageView()
        searchCellSeperator.image = def_termsAndConditionsVCSearchCellSeperator
        searchCellSeperator.contentMode = .scaleToFill
        searchCellSeperator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchCellSeperator)
        searchCellSeperator.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: def_termsAndConditionsVCSeachCellSeperatorPaddingTop).isActive = true
        searchCellSeperator.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchCellSeperator.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        searchCellSeperator.heightAnchor.constraint(equalToConstant: def_termsAndConditionsVCSeachCellSeperatorHeight).isActive = true
    }
    
    fileprivate func setupWebView() {
        webView = WKWebView()
        webView.backgroundColor = def_termsAndConditionsVCBackgroundColor
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        view.addSubview(webView)
        webView.topAnchor.constraint(equalTo: searchCellSeperator.bottomAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    fileprivate func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .gray
        view.addSubview(activityIndicator)
    }
    
    fileprivate func fetchWebData() {
        guard let url = url else { showAlert(); return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    @objc func closeButtonTapped(sender: UIButton!) {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func showAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: NSLocalizedString("webViewLoadingErrorTitle", comment: ""), message: NSLocalizedString("webViewLoadingErrorMessage", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { UIAlertAction in
                self.dismiss(animated: true, completion: nil)
            })
            self.present(alert, animated: true)
        }
    }
}
