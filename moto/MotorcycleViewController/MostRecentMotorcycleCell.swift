import UIKit

class MostRecentMotorcycleCell: UITableViewCell {

    private var backgroundImageView: UIImageView!
    private var nameBar: UIImageView!
    private var motorcycleBrandLabel: UILabel!
    private var motorcycleModelLabel: UILabel!
    private var dateLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.layer.cornerRadius = def_mostRecentCellCornerRadius
        self.selectionStyle = .none
        
        setupBackgroundImage()
        setupNameBar()
        setupMotorcycleBrandLabel()
        setupMotorcycleModelLabel()
        setupDateLabel()
    }
    
    fileprivate func setupBackgroundImage() {
        backgroundImageView = UIImageView()
        backgroundImageView.contentMode = .scaleAspectFit
        backgroundImageView.clipsToBounds = true
        backgroundImageView.layer.cornerRadius = def_mostRecentCellCornerRadius
        backgroundImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMinYCorner]
        backgroundImageView.image = def_mostRecentPlaceholder
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundImageView)
        backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -def_mostRecentCellNameBarHeight).isActive = true
        backgroundImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        backgroundImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    fileprivate func setupNameBar() {
        nameBar = UIImageView()
        nameBar.image = def_mostRecentCellNameBarImage
        nameBar.contentMode = .scaleAspectFill
        nameBar.clipsToBounds = true
        nameBar.layer.cornerRadius = def_mostRecentCellCornerRadius
        nameBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        nameBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameBar)
        nameBar.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -def_mostRecentCellNameBarGradientHeight).isActive = true
        nameBar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        nameBar.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        nameBar.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    fileprivate func setupMotorcycleBrandLabel() {
        motorcycleBrandLabel = UILabel()
        motorcycleBrandLabel.font = UIFont.systemFont(ofSize: def_mostRecentCellMotorcycleBrandLabelFontSize, weight: .medium)
        motorcycleBrandLabel.textColor = def_mostRecentCellMotorcycleBrandLabelColor
        motorcycleBrandLabel.minimumScaleFactor = def_mostRecentCellMotorcycleBrandLabelMinimumScaleFactor
        motorcycleBrandLabel.adjustsFontSizeToFitWidth = true
        motorcycleBrandLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(motorcycleBrandLabel)
        motorcycleBrandLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: def_mostRecentCellMotorcycleBrandLabelPaddingLR).isActive = true
        motorcycleBrandLabel.centerYAnchor.constraint(equalTo: nameBar.centerYAnchor, constant: def_mostRecentCellLabelCenterOffset).isActive = true
    }
    
    fileprivate func setupMotorcycleModelLabel() {
        motorcycleModelLabel = UILabel()
        motorcycleModelLabel.font = UIFont.systemFont(ofSize: def_mostRecentCellMotorcycleBrandLabelFontSize, weight: .regular)
        motorcycleModelLabel.textColor = def_mostRecentCellMotorcycleModelLabelColor
        motorcycleModelLabel.minimumScaleFactor = def_mostRecentCellMotorcycleBrandLabelMinimumScaleFactor
        motorcycleModelLabel.adjustsFontSizeToFitWidth = true
        motorcycleModelLabel.textAlignment = .left
        motorcycleModelLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(motorcycleModelLabel)
        motorcycleModelLabel.leftAnchor.constraint(equalTo: motorcycleBrandLabel.rightAnchor, constant: def_mostRecentCellMotorcycleModelLabelPaddingLR).isActive = true
        motorcycleModelLabel.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -def_mostRecentCellDateLabelMinWidth).isActive = true
        motorcycleModelLabel.centerYAnchor.constraint(equalTo: nameBar.centerYAnchor, constant: def_mostRecentCellLabelCenterOffset).isActive = true
    }
    
    fileprivate func setupDateLabel() {
        dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: def_mostRecentCellDateLabelFontSize, weight: .regular)
        dateLabel.textColor = def_mostRecentCellMotorcycleModelLabelColor
        dateLabel.minimumScaleFactor = def_mostRecentCellMotorcycleBrandLabelMinimumScaleFactor
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.textAlignment = .right
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dateLabel)
        dateLabel.leftAnchor.constraint(equalTo: motorcycleModelLabel.rightAnchor, constant: def_mostRecentCellMotorcycleModelLabelPaddingLR).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -def_mostRecentCellMotorcycleBrandLabelPaddingLR).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: nameBar.centerYAnchor, constant: def_mostRecentCellLabelCenterOffset).isActive = true
    }
    
    var backgroundImage: UIImage? {
        didSet {
            if backgroundImage != nil {
                self.backgroundImageView.contentMode = .scaleAspectFill
                self.backgroundImageView?.image = self.backgroundImage
            }
            else {
                self.backgroundImageView.contentMode = .scaleAspectFit
                self.backgroundImageView?.image = def_mostRecentPlaceholder
            }
        }
    }

    var motorcycleBrand: String? {
        didSet {
            motorcycleBrandLabel?.text = motorcycleBrand
        }
    }
    
    var motorcycleModel: String? {
        didSet {
            motorcycleModelLabel?.text = motorcycleModel
        }
    }

    var date: String? {
        didSet {
            dateLabel?.text = date
        }
    }
}
