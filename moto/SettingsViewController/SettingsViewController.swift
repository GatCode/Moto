import UIKit

struct settingsListItem {
    let header: String
    let name: String
    let link: String
}

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var closeButton: UIButton!
    private var closeImage: UIImageView!
    private var searchCellSeperator: UIImageView!
    private var tableView: UITableView!
    private var settingsList = [
        [settingsListItem](),
        [settingsListItem]()
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = tableView.indexPathForSelectedRow{
            tableView.deselectRow(at: index, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = def_settingsVCBackgroundColor
        setupCloseButton()
        createCellSeperator()
        fetchDataForTV()
        setupTableView()
    }
    
    @objc func closeButtonTapped(sender: UIButton!) {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setupCloseButton() {
        closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: def_settingsVCCloseButtonPaddingTop).isActive = true
        closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: def_settingsVCCloseButtonPaddingLeft).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: def_settingsVCCloseButtonWidthHeight).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: def_settingsVCCloseButtonWidthHeight).isActive = true
        
        closeImage = UIImageView()
        closeImage.image = def_settingsVCCloseIcon
        closeImage.contentMode = .scaleAspectFit
        closeImage.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addSubview(closeImage)
        closeImage.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: def_settingsVCCloseIconPaddingTop).isActive = true
        closeImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: def_settingsVCCloseIconPaddingLeft).isActive = true
        closeImage.widthAnchor.constraint(equalToConstant: def_settingsVCCloseIconWidthHeight).isActive = true
        closeImage.heightAnchor.constraint(equalToConstant: def_settingsVCCloseIconWidthHeight).isActive = true
    }
    
    fileprivate func createCellSeperator() {
        searchCellSeperator = UIImageView()
        searchCellSeperator.image = def_settingsVCCellSeperator
        searchCellSeperator.contentMode = .scaleToFill
        searchCellSeperator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchCellSeperator)
        searchCellSeperator.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: def_settingsVCCellSeperatorPaddingTop).isActive = true
        searchCellSeperator.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchCellSeperator.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        searchCellSeperator.heightAnchor.constraint(equalToConstant: def_settingsVCCellSeperatorHeight).isActive = true
    }
    
    fileprivate func fetchDataForTV() {
        settingsList[0].append(settingsListItem(header: NSLocalizedString("settingsHeader1", comment: ""), name: NSLocalizedString("settingsHeader1Item1", comment: ""), link: NSLocalizedString("termsOfServiceUrl", comment: "")))
        settingsList[0].append(settingsListItem(header: NSLocalizedString("settingsHeader1", comment: ""), name: NSLocalizedString("settingsHeader1Item2", comment: ""), link: NSLocalizedString("privacyPolicyUrl", comment: "")))
        settingsList[0].append(settingsListItem(header: NSLocalizedString("settingsHeader1", comment: ""), name: NSLocalizedString("settingsHeader1Item3", comment: ""), link: NSLocalizedString("disclaimerUrl", comment: "")))
        
        settingsList[1].append(settingsListItem(header: NSLocalizedString("settingsHeader2", comment: ""), name: NSLocalizedString("settingsHeader2Item1", comment: ""), link: NSLocalizedString("supportUrl", comment: "")))
    }
    
    fileprivate func setupTableView() {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = def_settingsVCFooterBackgroundColor
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "settingsCell")
        tableView.register(SettingsHeader.self, forCellReuseIdentifier: "settingsHeader")
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: searchCellSeperator.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsList[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return def_settingsVCHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {        
        let headerView = tableView.dequeueReusableCell(withIdentifier: "settingsHeader")
        if let headerView = headerView as? SettingsHeader {
            headerView.headerLabel.text = settingsList[section][0].header
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        if let cell = cell as? SettingsCell {
            cell.settingsLabel.text = settingsList[indexPath.section][indexPath.row].name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section <= settingsList.count else { showAlert(); return }
        guard indexPath.row <= settingsList[indexPath.section].count else { showAlert(); return }
        if let url = URL(string: settingsList[indexPath.section][indexPath.row].link) {
            if url == URL(string: NSLocalizedString("supportUrl", comment: "")) {
                UIApplication.shared.open(url)
            }
            else {
                let vc = TermsAndConditionsWebViewController()
                vc.url = url
                self.present(vc, animated: true, completion: nil)
            }
        }
        else {
            showAlert()
        }
    }
    
    fileprivate func showAlert() {
        let alert = UIAlertController(title: NSLocalizedString("termsAndConditionsParsingErrorTitle", comment: ""), message: NSLocalizedString("termsAndConditionsParsingErrorMessage", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { UIAlertAction in })
        self.present(alert, animated: true)
    }
}
