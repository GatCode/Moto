import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    private var closeButton: UIButton!
    private var closeImage: UIImageView!
    private var searchField: UITextField!
    private var searchCellSeperator: UIImageView!
    private var clearButton: UIButton!
    private var tableView: UITableView!
    private var motoDB: MotoDB?
    var searchResult = [MotorcycleEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = def_searchVCBackgroundColor
        setupDatabase()
        setupTitleBar()
        setupTableView()
        setupKeyboardNotification()
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
    
    fileprivate func setupTitleBar() {
        createCloseButton()
        createSearchField()
        createCellSeperator()
        createClearButton()
    }
    
    fileprivate func setupTableView() {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SearchCell.self, forCellReuseIdentifier: "searchCell")
        tableView.backgroundColor = def_motorcycleVCBackgroundColor
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: searchCellSeperator.bottomAnchor, constant: def_searchVCCellPaddingTop).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    fileprivate func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        searchField.resignFirstResponder()
        return true
    }
    
    fileprivate func createCloseButton() {
        closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: def_searchVCCloseButtonPaddingTop).isActive = true
        closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: def_searchVCCloseButtonPaddingLeft).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: def_searchVCCloseButtonWidthHeight).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: def_searchVCCloseButtonWidthHeight).isActive = true
        
        closeImage = UIImageView()
        closeImage.image = def_searchVCCloseIcon
        closeImage.contentMode = .scaleAspectFit
        closeImage.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addSubview(closeImage)
        closeImage.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: def_searchVCCloseIconPaddingTop).isActive = true
        closeImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: def_searchVCCloseIconPaddingLeft).isActive = true
        closeImage.widthAnchor.constraint(equalToConstant: def_searchVCCloseIconWidthHeight).isActive = true
        closeImage.heightAnchor.constraint(equalToConstant: def_searchVCCloseIconWidthHeight).isActive = true
    }
    
    fileprivate func createSearchField() {
        searchField = UITextField()
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.font = UIFont.systemFont(ofSize: def_searchVCSeachFieldFontSize, weight: .medium)
        searchField.textColor = def_searchVCSeachFieldFontColor
        searchField.placeholder = NSLocalizedString("searchFieldPlaceholder", comment: "")
        view.addSubview(searchField)
        searchField.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: def_searchVCSeachFieldPaddingTop).isActive = true
        searchField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: def_searchVCSeachFieldPaddingLR).isActive = true
        searchField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -def_searchVCSeachFieldPaddingLR).isActive = true
        searchField.heightAnchor.constraint(equalToConstant: def_searchVCSeachFieldHeight).isActive = true
        searchField.becomeFirstResponder()
        searchField.delegate = self
        searchField.addTarget(self, action: #selector(SearchViewController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    fileprivate func createCellSeperator() {
        searchCellSeperator = UIImageView()
        searchCellSeperator.image = def_searchVCSearchCellSeperator
        searchCellSeperator.contentMode = .scaleToFill
        searchCellSeperator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchCellSeperator)
        searchCellSeperator.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: def_searchVCSeachCellSeperatorPaddingTop).isActive = true
        searchCellSeperator.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchCellSeperator.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        searchCellSeperator.heightAnchor.constraint(equalToConstant: def_searchVCSeachCellSeperatorHeight).isActive = true
    }
    
    fileprivate func createClearButton() {
        clearButton = UIButton()
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        clearButton.setTitle(NSLocalizedString("clearButtonLabel", comment: ""), for: .normal)
        clearButton.setTitleColor(def_searchVCClearButtonFontColor, for: .normal)
        clearButton.titleLabel?.font = UIFont.systemFont(ofSize: def_searchVCClearButtonFontSize, weight: .regular)
        clearButton.contentMode = .right
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(clearButton)
        clearButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: def_searchVCClearButtonPaddingTop).isActive = true
        clearButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -def_searchVCClearButtonPaddingRight).isActive = true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.isEmpty == false {
            guard let term = textField.text else { return }
            guard let motoDB = motoDB else { return }
            motoDB.serchDatabase(searchTerm: term) { (result, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.showAlert()
                    }
                }
                else {
                    guard let result = result else { return }
                    self.searchResult = result
                }
            }
        }
        else {
            self.searchResult = []
        }
        
        tableView.reloadData()
    }
    
    @objc func closeButtonTapped(sender: UIButton!) {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func clearButtonTapped(sender: UIButton!) {
        searchField?.text = ""
        self.searchResult.removeAll()
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResult.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return def_searchVCCellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        if let cell = cell as? SearchCell {
            var modelExtention = ""
            if let extention = searchResult[indexPath.row].modelExtention {
                modelExtention = String(describing: extention)
            }
            cell.motorcycleLabel.text = "\(searchResult[indexPath.row].brand) \(searchResult[indexPath.row].model) \(modelExtention)"
            cell.dateLabel.text = searchResult[indexPath.row].years
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let details = searchResult[indexPath.row]
        let moto = MostRecentMotorcycle(id: details.id, brand: details.brand, model: details.model, modelExtention: details.modelExtention, year: details.years)
        MostRecentPersistentData.shared.saveToPersistentData(motorcycle: moto) { error in
            tappedMotorcycleID = details.id
            if error != nil {
                self.view.endEditing(true)
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
                self.view.endEditing(true)
                if let tabBarController = self.presentingViewController as? UITabBarController {
                    tabBarController.selectedIndex = 2
                    nrOfMostRecentMotorcycles += 1
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    fileprivate func showAlert() {
        self.view.endEditing(true)
        let alert = UIAlertController(title: NSLocalizedString("databaseErrorTitle", comment: ""), message: NSLocalizedString("databaseErrorMessage", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { UIAlertAction in
            tappedMotorcycleID = 0
            if let tabBarController = self.presentingViewController as? UITabBarController {
                tabBarController.selectedIndex = 0
                self.dismiss(animated: true, completion: nil)
            }
        })
        self.present(alert, animated: true)
    }
}
