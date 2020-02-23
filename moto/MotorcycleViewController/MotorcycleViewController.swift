import UIKit

class MotorcycleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var searchButton: UIButton!
    private var tableView: UITableView!
    private var topBackgroundView: UIView!
    private var firstTimeView: UIView!
    private var firstTimeLabel: UILabel!
    private var firstTimeImage: UIImageView!
    private var firstTimeSearchButton: UIButton!
    private var firstTimeDetectButton: UIButton!
    
    private var motoDB: MotoDB?
    private var mostRecentMotorcycles = [MostRecentMotorcycle]()
    let defaults = UserDefaults.standard
    
    override func viewWillAppear(_ animated: Bool) {
        setupDatabase()
        fetchMostRecentMotorcycles()
        tableView?.reloadData()
        if mostRecentMotorcycles.isEmpty == false {
            if let firstTimeView = firstTimeView {
                firstTimeView.isHidden = true
            }
        }
        nrOfMostRecentMotorcycles = mostRecentMotorcycles.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = def_motorcycleVCBackgroundColor
        setupSearchButton()
        setupTableView()
        setupTopBackground()
        fetchMostRecentMotorcycles()
        if mostRecentMotorcycles.isEmpty {
            setupFirstTimeView()
        }
    }
    
    fileprivate func setupFirstTimeView() {
        setupFirstTimeEssentials()
        setupFirstTimeMessageLabel()
        setupFirstTimeImage()
        setupFirstTimeSearchButton()
        setupFirstTimeDetectButton()
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
    
    fileprivate func setupSearchButton() {
        searchButton = UIButton()
        searchButton.setImage(def_motorcycleVCSearchButtonImage, for: .normal)
        searchButton.setImage(def_motorcycleVCSearchButtonImageTapped, for: .highlighted)
        searchButton.imageView?.contentMode = .scaleAspectFit
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        searchButton.layer.shadowColor = def_motorcycleVCSearchButtonShadowColor.cgColor
        searchButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        searchButton.layer.shadowRadius = def_motorcycleVCSearchButtonShadowRadius
        searchButton.layer.shadowOpacity = def_motorcycleVCSearchButtonShadowOpacity
        
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchButton)
        searchButton.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor, constant: def_motorcycleVCSearchButtonPaddingLR).isActive = true
        searchButton.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor, constant: -def_motorcycleVCSearchButtonPaddingLR).isActive = true
        searchButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        searchButton.bottomAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.topAnchor, constant: def_motorcycleVCSearchButtonMaxHeight).isActive = true
    }
    
    fileprivate func setupTableView() {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MostRecentMotorcycleCell.self, forCellReuseIdentifier: "mostRecentMotorcycleCell")
        tableView.backgroundColor = def_motorcycleVCBackgroundColor
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.clipsToBounds = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor, constant: def_motorcycleVCTableViewPaddingLR).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor, constant: -def_motorcycleVCTableViewPaddingLR).isActive = true
        tableView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: def_motorcycleVCTableViewPaddingTop).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    fileprivate func setupTopBackground() {
        topBackgroundView = UIView()
        topBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        topBackgroundView.backgroundColor = def_motorcycleVCBackgroundColor
        view.addSubview(topBackgroundView)
        view.sendSubviewToBack(topBackgroundView)
        view.sendSubviewToBack(tableView)
        topBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topBackgroundView.bottomAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: -def_motorcycleVCTopBackgroundOffset).isActive = true
    }
    
    fileprivate func fetchMostRecentMotorcycles() {
        MostRecentPersistentData.shared.getPersistentData { motorcycles, error in
            if error != nil {
                let errorTitle = NSLocalizedString("persistentDataFetchingErrorTitle", comment: "")
                let errorMessage = NSLocalizedString("persistentDataFetchingErrorMessage", comment: "")
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
            else {
                guard let motorcycles = motorcycles else { return }
                self.mostRecentMotorcycles = motorcycles
            }
        }
    }
    
    @objc func searchButtonTapped(sender: UIButton!) {
        self.present(SearchViewController(), animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return mostRecentMotorcycles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return def_mostRecentCellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: def_mostRecentCellSpacing))
        return footerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mostRecentMotorcycleCell", for: indexPath)
        if let cell = cell as? MostRecentMotorcycleCell {
            
            cell.layer.shadowColor = def_motorcycleVCSearchButtonShadowColor.cgColor
            cell.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            cell.layer.shadowRadius = def_motorcycleVCSearchButtonShadowRadius
            cell.layer.shadowOpacity = def_motorcycleVCSearchButtonShadowOpacity
            
            cell.backgroundImage = nil
            motoDB?.getMotorcycleImage(id: mostRecentMotorcycles[indexPath.section].id, completion: { image, error in
                if let image = image {
                    cell.backgroundImage = image
                }
            })
            cell.motorcycleBrand = mostRecentMotorcycles[indexPath.section].brand
            var modelExtention = ""
            if let extention = mostRecentMotorcycles[indexPath.section].modelExtention {
                modelExtention = String(describing: extention)
            }
            cell.motorcycleModel = "\(mostRecentMotorcycles[indexPath.section].model) \(modelExtention)"
            cell.date = mostRecentMotorcycles[indexPath.section].year
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tappedMotorcycleID = mostRecentMotorcycles[indexPath.section].id
        self.tableView.deselectRow(at: indexPath, animated: true)
        tabBarController?.selectedIndex = 2
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
    
    fileprivate func setupFirstTimeEssentials() {
        firstTimeView = UIView()
        firstTimeView.backgroundColor = def_motorcycleVCBackgroundColor
        firstTimeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(firstTimeView)
        firstTimeView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        firstTimeView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        firstTimeView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        firstTimeView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    fileprivate func setupFirstTimeMessageLabel() {
        firstTimeLabel = UILabel()
        firstTimeLabel.font = UIFont.systemFont(ofSize: def_motorcycleVCFirstTimeLabelFontSize, weight: .regular)
        firstTimeLabel.textColor = def_mostRecentCellMotorcycleModelLabelColor
        firstTimeLabel.text = NSLocalizedString("startMessage", comment: "")
        firstTimeLabel.numberOfLines = 0
        firstTimeLabel.textAlignment = .center
        firstTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        firstTimeView.addSubview(firstTimeLabel)
        firstTimeLabel.centerYAnchor.constraint(equalTo: firstTimeView.centerYAnchor, constant: -def_motorcycleVCFirstTimeLabelOffset).isActive = true
        firstTimeLabel.centerXAnchor.constraint(equalTo: firstTimeView.centerXAnchor).isActive = true
        firstTimeLabel.widthAnchor.constraint(equalToConstant: def_motorcycleVCFirstTimeViewWidth).isActive = true
    }
    
    fileprivate func setupFirstTimeImage() {
        firstTimeImage = UIImageView()
        firstTimeImage.image = def_motorcycleVCFirstTimeImage
        firstTimeImage.contentMode = .scaleAspectFit
        firstTimeImage.translatesAutoresizingMaskIntoConstraints = false
        firstTimeView.addSubview(firstTimeImage)
        firstTimeImage.centerYAnchor.constraint(equalTo: firstTimeView.centerYAnchor, constant: -def_motorcycleVCFirstTimeImageOffset).isActive = true
        firstTimeImage.leftAnchor.constraint(equalTo: firstTimeView.leftAnchor).isActive = true
        firstTimeImage.rightAnchor.constraint(equalTo: firstTimeView.rightAnchor).isActive = true
        firstTimeImage.heightAnchor.constraint(equalToConstant: def_motorcycleVCFirstTimeImageHeight).isActive = true
    }
    
    fileprivate func setupFirstTimeSearchButton() {
        firstTimeSearchButton = UIButton()
        firstTimeSearchButton.setBackgroundImage(def_motorcycleVCFirstTimeButtons, for: .normal)
        firstTimeSearchButton.contentMode = .scaleAspectFit
        firstTimeSearchButton.titleLabel?.font = UIFont.systemFont(ofSize: def_motorcycleVCFirstTimeButtonsFontSize, weight: .regular)
        firstTimeSearchButton.setTitleColor(def_motorcycleVCFirstTimeLabelFontColor, for: .normal)
        firstTimeSearchButton.setTitle(NSLocalizedString("firstTimeSearchButton", comment: ""), for: .normal)
        firstTimeSearchButton.addTarget(self, action: #selector(firstTimeSearchButtonTapped), for: .touchUpInside)
        firstTimeSearchButton.translatesAutoresizingMaskIntoConstraints = false
        firstTimeView.addSubview(firstTimeSearchButton)
        firstTimeSearchButton.centerYAnchor.constraint(equalTo: firstTimeView.centerYAnchor, constant: def_motorcycleVCFirstTimeSearchButtonOffset).isActive = true
        firstTimeSearchButton.centerXAnchor.constraint(equalTo: firstTimeView.centerXAnchor) .isActive = true
        firstTimeSearchButton.widthAnchor.constraint(equalToConstant: def_motorcycleVCFirstTimeViewWidth).isActive = true
        firstTimeSearchButton.heightAnchor.constraint(equalToConstant: def_motorcycleVCFirstTimeButtonsHeight).isActive = true
    }
    
    fileprivate func setupFirstTimeDetectButton() {
        firstTimeDetectButton = UIButton()
        firstTimeDetectButton.setBackgroundImage(def_motorcycleVCFirstTimeButtons, for: .normal)
        firstTimeDetectButton.contentMode = .scaleAspectFit
        firstTimeDetectButton.titleLabel?.font = UIFont.systemFont(ofSize: def_motorcycleVCFirstTimeButtonsFontSize, weight: .regular)
        firstTimeDetectButton.setTitleColor(def_motorcycleVCFirstTimeLabelFontColor, for: .normal)
        firstTimeDetectButton.setTitle(NSLocalizedString("firstTimeDetectButton", comment: ""), for: .normal)
        firstTimeDetectButton.addTarget(self, action: #selector(firstTimeDetectButtonTapped), for: .touchUpInside)
        firstTimeDetectButton.translatesAutoresizingMaskIntoConstraints = false
        firstTimeView.addSubview(firstTimeDetectButton)
        firstTimeDetectButton.centerYAnchor.constraint(equalTo: firstTimeView.centerYAnchor, constant: def_motorcycleVCFirstTimeDetectButtonOffset).isActive = true
        firstTimeDetectButton.centerXAnchor.constraint(equalTo: firstTimeView.centerXAnchor) .isActive = true
        firstTimeDetectButton.widthAnchor.constraint(equalToConstant: def_motorcycleVCFirstTimeViewWidth).isActive = true
        firstTimeDetectButton.heightAnchor.constraint(equalToConstant: def_motorcycleVCFirstTimeButtonsHeight).isActive = true
    }
    
    @objc func firstTimeSearchButtonTapped(sender: UIButton!) {
        self.present(SearchViewController(), animated: true, completion: nil)
    }
    
    @objc func firstTimeDetectButtonTapped(sender: UIButton!) {
        tabBarController?.selectedIndex = 1
    }
}
