import UIKit

class SearchCell: UITableViewCell {

    var motorcycleLabel: UILabel!
    var dateLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupBasicCell()
        setupMotorcycleLabel()
        setupDateLabel()
    }
    
    fileprivate func setupBasicCell() {
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets(top: 0, left: def_searchVCCellPaddingLR, bottom: 0, right: def_searchVCCellPaddingLR)
        self.backgroundColor = def_searchVCBackgroundColor
    }

    fileprivate func setupMotorcycleLabel() {
        motorcycleLabel = UILabel()
        motorcycleLabel.font = UIFont.systemFont(ofSize: def_searchVCCellMotorcycleLabelFontSize, weight: .regular)
        motorcycleLabel.textColor = def_searchVCCellLabelsFontColor
        motorcycleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(motorcycleLabel)
        motorcycleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: def_searchVCCellPaddingLR).isActive = true
        motorcycleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -def_searchVCCellPaddingLR).isActive = true
        motorcycleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -def_searchVCCellLabelsOffset).isActive = true
    }
    
    fileprivate func setupDateLabel() {
        dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: def_searchVCCellDateLabelFontSize, weight: .regular)
        dateLabel.textColor = def_searchVCCellLabelsFontColor
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dateLabel)
        dateLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: def_searchVCCellPaddingLR).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -def_searchVCCellPaddingLR).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: def_searchVCCellLabelsOffset).isActive = true
    }
}
