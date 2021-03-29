//
//  MovieDetailVC.swift
//  TV Series App
//
//  Created by David T on 3/18/21.
//

import UIKit

final class SerieDetailVC: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let collCellId = "collectionCellId"
    
    var tvSerieId: TVSeries?
    var tvResults = [TVSeries]()
    
    lazy var absenceOfValue = "Nothing to show"
    lazy var flowLayot = UICollectionViewFlowLayout()
    
    let suggestedTitle = UILabel()
    
    lazy var descriptionData = [
        "Overview",
        "Name",
        "First Air",
        "Countries",
        "Language"
    ]
    
    lazy var deviceModelId = [
        "iPhone 6 Plus",
        "iPhone 6s Plus",
        "iPhone 7 Plus",
        "iPhone 8 Plus"
    ]
    
    lazy var listOfDataToShow = [
        tvSerieId?.overview ?? absenceOfValue,
        tvSerieId?.original_name ?? absenceOfValue,
        tvSerieId?.first_air_date ?? absenceOfValue,
        tvSerieId?.origin_country.first ?? absenceOfValue,
        tvSerieId?.original_language ?? absenceOfValue
    ]
    
    deinit { print("OS reclaiming memory for DetailVC - No Ratain Cycle/Leak!") }
    
    let tableCellId = "tableCellId"
    
    lazy var noImageLabel: UILabel = {
        let noImageLabel = UILabel()
        noImageLabel.font = .boldSystemFont(ofSize: 17)
        noImageLabel.textAlignment = .center
        noImageLabel.backgroundColor = .clear
        noImageLabel.textColor = dynamicSubColors
        noImageLabel.text = "No image"
        return noImageLabel
    }()
    
    lazy var customImageView: UIImageView = {
        let customImageView = UIImageView()
        customImageView.backgroundColor = .clear

        if let imageURL = tvSerieId?.backdrop_path {
            customImageView.loadImageUsingCacheWithURL(urlString: "https://image.tmdb.org/t/p/w500/\(imageURL)")
        }
        return customImageView
    }()
    
    private lazy var suggestedBackgroundView: UIView = {
        let suggestedBackgroundView = UIView()
        suggestedBackgroundView.backgroundColor = .clear
        return suggestedBackgroundView
    }()
    
    lazy var customCollectionView: UICollectionView = {
        let customCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayot)
        flowLayot.scrollDirection = .horizontal
        flowLayot.itemSize = CGSize(width: 140, height: 200)
        flowLayot.minimumLineSpacing = 3
        customCollectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: collCellId)
        customCollectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        customCollectionView.showsHorizontalScrollIndicator = false
        customCollectionView.backgroundColor = .clear
        customCollectionView.delegate = self
        customCollectionView.dataSource = self
        return customCollectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = tvSerieId?.name
        tableView.separatorStyle = .none
        view.backgroundColor = dynamicBackgroundColors
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: tableCellId)
        
        
        if let value = tvSerieId {
            getSeries(type: value.id, similar: "similar", language: "en-US", page: 1)
        }
    }
    
    fileprivate func pushToDetailView(tvId: TVSeries) {
        let detailViewController = SerieDetailVC()
        detailViewController.tvSerieId = tvId
        
        if UIDevice.current.userInterfaceIdiom == .pad || deviceModelId.contains(UIDevice.current.modelName) && UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .landscapeLeft {
            let rootViewController = UINavigationController(rootViewController: detailViewController)
            showDetailViewController(rootViewController, sender: self)
        } else {
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    private func getSeries(type: StringIntProtocol, similar: String, language: String, page: Int) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            NetworkRequest.shared.getTvSeries(type: type, tv: "tv", similar: similar, search: nil, query: nil, language: language, page: page) { [weak self] result in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    
                    switch result {
                    case .success(let list):
                        self.tvResults.append(contentsOf: list.results)
                        self.customCollectionView.reloadData()
                    case .failure(let error):
                        self.suggestedTitle.text = "No suggestions to show"
                        print(error)
                    }
                }
            }
        }
    }
    
    private func headerSetUp(header: UIView) {

        header.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(header)
        
        header.heightAnchor.constraint(equalToConstant: 230.0).isActive = true
        header.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        header.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        header.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        header.addSubview(noImageLabel)
        header.addSubview(customImageView)
        
        noImageLabel.fillSuperview()
        customImageView.fillSuperview()
        
    }
    
    private func sectionTwoHeader() {
        
        suggestedTitle.font = .boldSystemFont(ofSize: 20)
        suggestedTitle.textAlignment = .left
        suggestedTitle.textColor = dynamicSubColors
        suggestedTitle.text = "Suggested"
        
        suggestedBackgroundView.addSubview(suggestedTitle)
        
        suggestedBackgroundView.addSubview(customCollectionView)
        
        if #available(iOS 11.0, *) {
            
            suggestedTitle.layout(top: suggestedBackgroundView.safeAreaLayoutGuide.topAnchor, leading: suggestedBackgroundView.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 13, left: 13, bottom: 0, right: 0), size: .init(width: 100, height: 22))
            
            customCollectionView.layout(top: suggestedTitle.safeAreaLayoutGuide.bottomAnchor, leading: suggestedBackgroundView.safeAreaLayoutGuide.leadingAnchor, bottom: suggestedBackgroundView.safeAreaLayoutGuide.bottomAnchor, trailing: suggestedBackgroundView.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 5, left: 0, bottom: 0, right: 0))
        } else {
            
            suggestedTitle.layout(top: suggestedBackgroundView.topAnchor, leading: suggestedBackgroundView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 13, left: 13, bottom: 0, right: 0), size: .init(width: 100, height: 22))
            
            customCollectionView.layout(top: suggestedTitle.bottomAnchor, leading: suggestedBackgroundView.leadingAnchor, bottom: suggestedBackgroundView.bottomAnchor, trailing: suggestedBackgroundView.trailingAnchor, padding: .init(top: 5, left: 0, bottom: 0, right: 0))
        }
    }
    
    //  MARK: - collectionView Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tvResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collCellId, for: indexPath) as! DetailCollectionViewCell
        cell.tvSeriesId = tvResults[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let resultsId = tvResults[indexPath.row]
        pushToDetailView(tvId: resultsId)
    }
    
    // MARK: - tableView Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? UITableView.automaticDimension : 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? listOfDataToShow.count : 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 230.0 : 270.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellId, for: indexPath) as! DetailTableViewCell
        cell.backgroundColor = dynamicBackgroundColors
        let highlighedColor = UIView()
        highlighedColor.backgroundColor = .clear
        cell.selectedBackgroundView = highlighedColor
        
        cell.customTextView.text = listOfDataToShow[indexPath.row]
        cell.descriptionLabel.text = descriptionData[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerSecOne = UIView()
        headerSetUp(header: headerSecOne)
        sectionTwoHeader()
        return section == 0 ? headerSecOne : suggestedBackgroundView
    }
    
}
