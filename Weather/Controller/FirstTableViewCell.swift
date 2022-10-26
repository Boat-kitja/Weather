//
//  FirstTableViewCell.swift
//  Weather
//
//  Created by Kitja  on 23/10/2565 BE.
//

import UIKit

class FirstTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView:UICollectionView!
    var test = [SetCollectionViewData]()
    let hour = Calendar.current.component(.hour, from: Date())
    
    static let identifier = "FirstTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "FirstTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: "FirstCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FirstCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return test.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirstCollectionViewCell", for: indexPath) as! FirstCollectionViewCell
        cell.mainLabels.text = "\(String(describing: test[indexPath.row].temp!))°"
        
        if test[indexPath.row].time == hour{
            cell.dateLabel.text = "Now"
        }else{
            cell.dateLabel.text = "\(String(describing: test[indexPath.row].time!))"
        }
        
        cell.mainImage.image = UIImage(systemName: test[indexPath.row].code!)
        return cell
    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 50, height: 100)
//
//    }
    
    
    
}
