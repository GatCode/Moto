import UIKit

class DetailsCell: UITableViewCell {

    private var backgroundImageView: UIImageView!
    private var mainImageView: UIImageView!
    private var dataIconView: UIImageView!
    var categoryLabel: UILabel!
    var informationLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = def_motorcycleVCBackgroundColor
        setupBackgroundImage()
        setupMainImage()
        setupDataIcon()
        setupCategoryLabel()
        setupInformationLabel()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    fileprivate func setupBackgroundImage() {
        backgroundImageView = UIImageView()
        backgroundImageView.contentMode = .scaleToFill
        backgroundImageView.layer.cornerRadius = def_detailsCellCornerRadius
        backgroundImageView.image = def_mostRecentPlaceholder
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundImageView)
        backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        backgroundImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        backgroundImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    fileprivate func setupMainImage() {
        mainImageView = UIImageView()
        mainImageView.contentMode = .scaleAspectFit
        mainImageView.layer.cornerRadius = def_detailsCellCornerRadius
        mainImageView.layer.masksToBounds = true
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainImageView)
        mainImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: def_detailsCellMainImagePaddingTB).isActive = true
        mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -def_detailsCellMainImagePaddingTB).isActive = true
        mainImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: def_detailsCellMainImagePaddingLR).isActive = true
        mainImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -def_detailsCellMainImagePaddingLR).isActive = true
    }
    
    fileprivate func setupDataIcon() {
        dataIconView = UIImageView()
        dataIconView.contentMode = .scaleAspectFit
        dataIconView.layer.cornerRadius = def_detailsCellCornerRadius
        dataIconView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dataIconView)
        dataIconView.topAnchor.constraint(equalTo: self.topAnchor, constant: def_detailsCellDataIconPaddingTop).isActive = true
        dataIconView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: def_detailsCellDataIconPaddingLeft).isActive = true
        dataIconView.widthAnchor.constraint(equalToConstant: def_detailsCellDataIconWidthAndHeight).isActive = true
        dataIconView.heightAnchor.constraint(equalToConstant: def_detailsCellDataIconWidthAndHeight).isActive = true
    }
    
    fileprivate func setupCategoryLabel() {
        categoryLabel = UILabel()
        categoryLabel.font = UIFont.systemFont(ofSize: def_detailsCellCategoryLabelFontSize, weight: .medium)
        categoryLabel.textColor = def_detailsCellCategoryLabelFontColor
        categoryLabel.minimumScaleFactor = def_detailsVCMotorcycleLabelMinimumScaleFactor
        categoryLabel.adjustsFontSizeToFitWidth = true
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(categoryLabel)
        categoryLabel.leftAnchor.constraint(equalTo: dataIconView.rightAnchor, constant: def_detailsCellCategoryLabelPaddingLeft).isActive = true
        categoryLabel.rightAnchor.constraint(equalTo: self.centerXAnchor, constant: def_detailsCellInformationLabelPaddingLeft).isActive = true
        categoryLabel.centerYAnchor.constraint(equalTo: dataIconView.centerYAnchor).isActive = true
    }
    
    fileprivate func setupInformationLabel() {
        informationLabel = UILabel()
        informationLabel.font = UIFont.systemFont(ofSize: def_detailsCellCategoryLabelFontSize, weight: .regular)
        informationLabel.textColor = def_detailsCellCategoryLabelFontColor
        informationLabel.minimumScaleFactor = def_detailsVCMotorcycleLabelMinimumScaleFactor
        informationLabel.adjustsFontSizeToFitWidth = true
        informationLabel.translatesAutoresizingMaskIntoConstraints = false
        informationLabel.textAlignment = .right
        informationLabel.numberOfLines = 0;
        addSubview(informationLabel)
        informationLabel.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: def_detailsCellInformationLabelPaddingLeft).isActive = true
        informationLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -def_detailsCellInformationLabelPaddingRight).isActive = true
        informationLabel.topAnchor.constraint(equalTo: dataIconView.centerYAnchor, constant: -informationLabel.font.lineHeight / 2).isActive = true
    }
    
    var backgroundImage: UIImage? {
        didSet {
            self.backgroundImageView?.image = backgroundImage
        }
    }
    
    var mainImage: UIImage? {
        didSet {
            if mainImage == def_detailsCellMainImagePlaceholder {
                self.mainImageView?.contentMode = .scaleAspectFit
            }
            else {
                self.mainImageView?.contentMode = .scaleAspectFill
            }
            self.mainImageView?.image = mainImage
        }
    }
    
    var dataIcon: UIImage? {
        didSet {
            self.dataIconView?.image = dataIcon
        }
    }
}
