import StoreKit
import UIKit

struct detailCellInformation {
    let cellHeightIdentifier: Int
    let backgroundImage: UIImage?
    let mainImage: UIImage?
    let iconImage: UIImage?
    let categoryLabelText: String
    let informationLabelText: String
}

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var topBarImageView: UIImageView!
    private var topBarSettingsIcon: UIButton!
    private var motorcycleLabel: UILabel!
    private var tableView: UITableView!
    private var selectFirstView: UIView!
    private var selectFirstLabel: UILabel!
    private var previousMotorcycleID: Int64 = 0
    
    private var motorcycleDetails: MotorcycleEntry?
    private var tableInformation = [detailCellInformation]()
    private var motoDB: MotoDB?
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = def_motorcycleVCBackgroundColor
        setupDatabase()
        fetchMotorcycleDetails()
        setupTopBar()
        setupTitleLabel()
        setupTableView()
        
        if motorcycleDetails == nil {
            setupSelectFirstView()
            setupTopBar()
        }
        else {
            checkAndShowReviewView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    fileprivate func fetchMotorcycleDetails() {
        guard let motoDB = motoDB else { return }
        motoDB.getMotorcycleById(id: tappedMotorcycleID) { motorcycle, error in
            if error != nil && tappedMotorcycleID != 0 {
                DispatchQueue.main.async {
                    self.showAlert()
                }
            }
            else {
                guard let motorcycle = motorcycle else { return }
                self.motorcycleDetails = motorcycle
            }
        }
    }
    
    fileprivate func setupTopBar() {
        topBarImageView = UIImageView()
        topBarImageView.contentMode = .scaleAspectFit
        topBarImageView.image = def_detailsVCTopBarImage
        topBarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBarImageView)
        topBarImageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: -def_detailsVCTopBarOffset).isActive = true
        topBarImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topBarImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topBarImageView.heightAnchor.constraint(equalToConstant: def_detailsVCTopBarHeight).isActive = true
        
        let topBackground = UIImageView()
        topBackground.backgroundColor = def_detailsVCTopBarHeaderColor
        topBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBackground)
        topBackground.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topBackground.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topBackground.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topBackground.bottomAnchor.constraint(equalTo: topBarImageView.centerYAnchor).isActive = true
        
        motorcycleLabel = UILabel()
        motorcycleLabel.font = UIFont.systemFont(ofSize: def_detailsVCMotorcycleLabelFontSize, weight: .medium)
        motorcycleLabel.textColor = def_detailsVCMotorcycleLabelFontColor
        motorcycleLabel.minimumScaleFactor = def_detailsVCMotorcycleLabelMinimumScaleFactor
        motorcycleLabel.adjustsFontSizeToFitWidth = true
        motorcycleLabel.textAlignment = .center
        motorcycleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(motorcycleLabel)
        motorcycleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: def_detailsVCMotorcycleLabelPaddingLR).isActive = true
        motorcycleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -def_detailsVCMotorcycleLabelPaddingLR).isActive = true
        motorcycleLabel.centerYAnchor.constraint(equalTo: topBarImageView.centerYAnchor, constant: def_detailsVCMotorcycleLabelOffset).isActive = true
        
        topBarSettingsIcon = UIButton()
        topBarSettingsIcon.setImage(def_detailsVCTopBarSettingsIcon, for: .normal)
        topBarSettingsIcon.contentMode = .scaleAspectFit
        topBarSettingsIcon.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        topBarSettingsIcon.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBarSettingsIcon)
        topBarSettingsIcon.centerYAnchor.constraint(equalTo: topBarImageView.centerYAnchor, constant: def_detailsVCMotorcycleLabelOffset).isActive = true
        topBarSettingsIcon.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -def_detailsVCTopBarInfoIconPaddingR).isActive = true
        topBarSettingsIcon.widthAnchor.constraint(equalToConstant: def_detailsVCTopBarInfoIconWidth).isActive = true
    }
    
    @objc func infoButtonTapped(sender: UIButton!) {
        self.present(SettingsViewController(), animated: true, completion: nil)
    }
    
    fileprivate func setupTitleLabel() {
        guard let motorcycle = motorcycleDetails else { return }
        var extention = ""
        if let motorcycleExtention = motorcycle.modelExtention {
            extention = motorcycleExtention
        }
        self.motorcycleLabel.text = "\(motorcycle.brand) \(motorcycle.model) \(extention)"
    }
    
    fileprivate func setupSelectFirstView() {
        selectFirstView = UIView()
        selectFirstView.frame = view.frame
        selectFirstView.backgroundColor = def_motorcycleVCBackgroundColor
        view.addSubview(selectFirstView)
        
        selectFirstLabel = UILabel()
        selectFirstLabel.font = UIFont.systemFont(ofSize: def_detailsStartLabelFontSize, weight: .regular)
        selectFirstLabel.textColor = def_detailsStartLabelFontColor
        selectFirstLabel.text = NSLocalizedString("notChosenYet", comment: "")
        selectFirstLabel.textAlignment = .center
        selectFirstLabel.lineBreakMode = .byWordWrapping
        selectFirstLabel.numberOfLines = 0
        selectFirstLabel.translatesAutoresizingMaskIntoConstraints = false
        selectFirstView.addSubview(selectFirstLabel)
        selectFirstLabel.leftAnchor.constraint(equalTo: selectFirstView.leftAnchor, constant: def_detailsStartLabelPaddingLR).isActive = true
        selectFirstLabel.rightAnchor.constraint(equalTo: selectFirstView.rightAnchor, constant: -def_detailsStartLabelPaddingLR).isActive = true
        selectFirstLabel.centerYAnchor.constraint(equalTo: selectFirstView.centerYAnchor, constant: -def_detailsStartLabelOffset).isActive = true
    }
    
    fileprivate func checkAndShowReviewView() {
        if nrOfMostRecentMotorcycles >= 3, tappedMotorcycleID != previousMotorcycleID {
            SKStoreReviewController.requestReview()
        }
    }
    
    fileprivate func setupTableView() {
        setupTableInformation()
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DetailsCell.self, forCellReuseIdentifier: "detailsCell")
        tableView.backgroundColor = def_motorcycleVCBackgroundColor
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: def_detailsCellBottomSpaceing, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor, constant: def_detailsVCMotorcycleTableViewPaddingLR).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor, constant: -def_detailsVCMotorcycleTableViewPaddingLR).isActive = true
        tableView.topAnchor.constraint(equalTo: topBarImageView.bottomAnchor, constant: def_detailsVCMotorcycleTableViewPaddingTop).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    fileprivate func setupTableInformation() {
        tableInformation = [detailCellInformation]()
        guard let motorcycleDetails = motorcycleDetails else { return }

        // main image
        var details = detailCellInformation(cellHeightIdentifier: 4, backgroundImage: nil, mainImage: def_detailsCellMainImagePlaceholder, iconImage: nil, categoryLabelText: "", informationLabelText: "")
        if let imageData = motorcycleDetails.image {
            if let image = UIImage(data: imageData) {
                details = detailCellInformation(cellHeightIdentifier: 4, backgroundImage: UIImage(), mainImage: image, iconImage: nil, categoryLabelText: "", informationLabelText: "")
            }
        }
        tableInformation.append(details)
        
        // caution
        details = detailCellInformation(cellHeightIdentifier: 2, backgroundImage: def_detailsCellBackground, mainImage: nil, iconImage: def_detailsCellCautionIcon, categoryLabelText: NSLocalizedString("cautionLabel", comment: ""), informationLabelText: NSLocalizedString("cautionLabelMessage", comment: ""))
        tableInformation.append(details)
        
        // years
        details = detailCellInformation(cellHeightIdentifier: 1, backgroundImage: def_detailsCellBackground, mainImage: nil, iconImage: def_detailsCellYearsIcon, categoryLabelText: NSLocalizedString("yearsLabel", comment: ""), informationLabelText: motorcycleDetails.years)
        tableInformation.append(details)
        
        // tire pressure
        if let tirePressureFront = motorcycleDetails.tirePressureFront,let tirePressureBack = motorcycleDetails.tirePressureBack {
            details = detailCellInformation(cellHeightIdentifier: 2, backgroundImage: def_detailsCellBackground, mainImage: nil, iconImage: def_detailsCellTireIcon, categoryLabelText: NSLocalizedString("tirePressureLabel", comment: ""), informationLabelText: "\(NSLocalizedString("tirePressureFrontLabel", comment: "")) \(tirePressureFront) Bar \n \(NSLocalizedString("tirePressureBackLabel", comment: "")) \(tirePressureBack) Bar")
            tableInformation.append(details)
        }
        
        // spark plug
        if let sparkPlug = motorcycleDetails.sparkPlug {
            details = detailCellInformation(cellHeightIdentifier: 1, backgroundImage: def_detailsCellBackground, mainImage: nil, iconImage: def_detailsCellSparkPlugIcon, categoryLabelText: NSLocalizedString("sparkPlugLabel", comment: ""), informationLabelText: sparkPlug)
            tableInformation.append(details)
        }
        
        // engine oil
        if let engineOil = motorcycleDetails.engineOil {
            var oilString = engineOil
            var oilCellHeight = 1
            if let oilWithFiler = motorcycleDetails.oilWithFilter {
                oilString.append("\n \(NSLocalizedString("engineOilWithFilerLabel", comment: "")) \(oilWithFiler) l")
                oilCellHeight += 1
            }
            if let oilWithoutFiler = motorcycleDetails.oilWithoutFilter {
                oilString.append("\n \(NSLocalizedString("engineOilWithoutFilerLabel", comment: "")) \(oilWithoutFiler) l")
                oilCellHeight += 1
            }
            details = detailCellInformation(cellHeightIdentifier: oilCellHeight, backgroundImage: def_detailsCellBackground, mainImage: nil, iconImage: def_detailsCellOilIcon, categoryLabelText: NSLocalizedString("engineOilLabel", comment: ""), informationLabelText: oilString)
            tableInformation.append(details)
        }
        
        // brake fluid
        if let brakeFluid = motorcycleDetails.brakeFluid {
            details = detailCellInformation(cellHeightIdentifier: 1, backgroundImage: def_detailsCellBackground, mainImage: nil, iconImage: def_detailsCellBrakeFluidIcon, categoryLabelText: NSLocalizedString("brakeFluidLabel", comment: ""), informationLabelText: brakeFluid)
            tableInformation.append(details)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableInformation.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableInformation[indexPath.section].cellHeightIdentifier {
        case 1:
            return def_detailsCellHeight1
        case 2:
            return def_detailsCellHeight2
        case 3:
            return def_detailsCellHeight3
        case 4:
            return def_detailsCellHeight4
        default:
            return def_detailsCellHeight1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return def_detailsCellSpacing
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = def_detailsCellSpacingColor
        return footerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath)
        if let cell = cell as? DetailsCell {            
            cell.backgroundImage = tableInformation[indexPath.section].backgroundImage
            cell.mainImage = tableInformation[indexPath.section].mainImage
            cell.dataIcon = tableInformation[indexPath.section].iconImage
            cell.categoryLabel.text = tableInformation[indexPath.section].categoryLabelText
            cell.informationLabel.text = tableInformation[indexPath.section].informationLabelText
        }
        return cell
    }
    
    fileprivate func showAlert() {
        let alert = UIAlertController(title: NSLocalizedString("databaseErrorTitle", comment: ""), message: NSLocalizedString("databaseErrorMessage", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { UIAlertAction in
            self.motorcycleDetails = nil
            self.tabBarController?.selectedIndex = 0
        })
        self.present(alert, animated: true)
    }
}
