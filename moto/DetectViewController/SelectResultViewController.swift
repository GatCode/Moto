import UIKit

class SelectResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    public var additiveMotorcycleIds: [Int64]?
    private var additiveMotorcycles = [MotorcycleEntry]()
    
    private var closeButton: UIButton!
    private var closeImage: UIImageView!
    private var selectLabel: UILabel!
    private var searchCellSeperator: UIImageView!
    private var tableView: UITableView!
    private var motoDB: MotoDB?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = def_searchVCBackgroundColor
        setupDatabase()
        setupTitleBar()
        setupTableView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        additiveMotorcycles.removeAll()
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
        createSelectLabel()
        createCellSeperator()
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
    
    fileprivate func createSelectLabel() {
        selectLabel = UILabel()
        selectLabel.translatesAutoresizingMaskIntoConstraints = false
        selectLabel.font = UIFont.systemFont(ofSize: def_searchVCSeachFieldFontSize, weight: .medium)
        selectLabel.textColor = def_searchVCSeachFieldFontColor
        selectLabel.text = NSLocalizedString("selectMotorcycleLabel", comment: "")
        view.addSubview(selectLabel)
        selectLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: def_searchVCSeachFieldPaddingTop).isActive = true
        selectLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: def_searchVCSeachFieldPaddingLR).isActive = true
        selectLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -def_searchVCSeachFieldPaddingLR).isActive = true
        selectLabel.heightAnchor.constraint(equalToConstant: def_searchVCSeachFieldHeight).isActive = true
    }
    
    fileprivate func createCellSeperator() {
        searchCellSeperator = UIImageView()
        searchCellSeperator.image = def_searchVCSearchCellSeperator
        searchCellSeperator.contentMode = .scaleToFill
        searchCellSeperator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchCellSeperator)
        searchCellSeperator.topAnchor.constraint(equalTo: selectLabel.bottomAnchor, constant: def_searchVCSeachCellSeperatorPaddingTop).isActive = true
        searchCellSeperator.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchCellSeperator.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        searchCellSeperator.heightAnchor.constraint(equalToConstant: def_searchVCSeachCellSeperatorHeight).isActive = true
    }
    
    fileprivate func setupTableView() {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SearchCell.self, forCellReuseIdentifier: "additiveCell")
        tableView.backgroundColor = def_motorcycleVCBackgroundColor
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: searchCellSeperator.bottomAnchor, constant: def_selectResultVCCellPaddingTop).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    @objc func closeButtonTapped(sender: UIButton!) {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.additiveMotorcycleIds?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return def_selectResultVCCellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "additiveCell", for: indexPath)
        if let cell = cell as? SearchCell {
            guard let motoDB = motoDB else { return cell }
            guard let additiveMotorcycleIds = additiveMotorcycleIds else { return cell }
            guard indexPath.row <= additiveMotorcycleIds.count else { return cell }
            motoDB.getMotorcycleById(id: additiveMotorcycleIds[indexPath.row]) { motorcycle, error in
                if error != nil {
                    DispatchQueue.main.async {
                        self.showAlert()
                    }
                }
                else {
                    guard let motorcycle = motorcycle else { return }
                    cell.motorcycleLabel.text = "\(motorcycle.brand) \(motorcycle.model) \(motorcycle.modelExtention ?? "")"
                    cell.dateLabel.text = motorcycle.years
                    self.additiveMotorcycles.append(motorcycle)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row <= additiveMotorcycles.count else { showAlert(); return }
        let details = additiveMotorcycles[indexPath.row]
        
        let moto = MostRecentMotorcycle(id: details.id, brand: details.brand, model: details.model, modelExtention: details.modelExtention, year: details.years)
        MostRecentPersistentData.shared.saveToPersistentData(motorcycle: moto) { error in
            tappedMotorcycleID = details.id
            if error != nil {
                let alert = UIAlertController(title: NSLocalizedString("persistentDataSavingErrorTitle", comment: ""), message: NSLocalizedString("persistentDataSavingErrorMessage", comment: ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { UIAlertAction in
                    if let tabBarController = self.presentingViewController as? UITabBarController {
                        tabBarController.selectedIndex = 1
                        self.dismiss(animated: true, completion: nil)
                    }
                })
                self.present(alert, animated: true)
            }
            else {
                if let tabBarController = self.presentingViewController as? UITabBarController {
                    tabBarController.selectedIndex = 2
                    nrOfMostRecentMotorcycles += 1
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    fileprivate func showAlert() {
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
