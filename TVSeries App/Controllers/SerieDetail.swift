//
//  MovieDetailVC.swift
//  TV Series App
//
//  Created by David T on 3/18/21.
//

import UIKit

final class SerieDetail: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var tvSerieId: TVSeries? {
        didSet {
            if let backdropPath = tvSerieId?.backdropPath, let id = tvSerieId?.id {
                customImageView.loadImageUsingCacheWithURL(urlString: "\(NetworkConstants.backdropPath)/\(backdropPath)")
                viewModel?.fetchSimilar(serieId: id)
            }
        }
    }
    
    var viewModel: DetailViewModel!
    
    private let collCellId = "collectionCellId"
    private let tableCellId = "tableCellId"
    private lazy var absenceOfValue = "Nothing to show"
    private lazy var flowLayot = UICollectionViewFlowLayout()
    private let suggestedTitle = UILabel()
    
    private lazy var listOfDataToShow = [
        tvSerieId?.overview ?? absenceOfValue,
        tvSerieId?.originalName ?? absenceOfValue,
        tvSerieId?.firstAirDate ?? absenceOfValue,
        tvSerieId?.originCountry.first ?? absenceOfValue,
        tvSerieId?.originalLanguage ?? absenceOfValue
    ]
    
    deinit { print("OS reclaiming memory for DetailController - No Ratain Cycle/Leak!") }
    
    private lazy var noImageLabel: UILabel = {
        let noImageLabel = UILabel()
        noImageLabel.font = .boldSystemFont(ofSize: 17)
        noImageLabel.textAlignment = .center
        noImageLabel.backgroundColor = .clear
        noImageLabel.textColor = Constants.dynamicSubColors
        noImageLabel.text = "No image"
        return noImageLabel
    }()
    
    private lazy var customImageView: UIImageView = {
        let customImageView = UIImageView()
        customImageView.backgroundColor = .clear
        return customImageView
    }()
    
    private lazy var suggestedBackgroundView: UIView = {
        let suggestedBackgroundView = UIView()
        suggestedBackgroundView.backgroundColor = .clear
        return suggestedBackgroundView
    }()
    
    private lazy var customCollectionView: UICollectionView = {
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
        view.backgroundColor = Constants.dynamicBackgroundColors
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: tableCellId)
        
        
        viewModel = DetailViewModel(APICall.shared)
        viewModel.delegate = self
        bindViewModel()
        if let id = tvSerieId?.id {
            viewModel.fetchSimilar(serieId: id)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.delegate = nil
    }
    
    private func bindViewModel() {
        viewModel?.response.bind({ [weak self] _ in
            DispatchQueue.main.async {
                self?.customCollectionView.reloadData()
            }
        })
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
        suggestedTitle.textColor = Constants.dynamicSubColors
        suggestedTitle.text = "Suggested"
        
        suggestedBackgroundView.addSubview(suggestedTitle)
        
        suggestedBackgroundView.addSubview(customCollectionView)
        
        suggestedTitle.layout(top: suggestedBackgroundView.safeAreaLayoutGuide.topAnchor, leading: suggestedBackgroundView.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 13, left: 13, bottom: 0, right: 0), size: .init(width: 100, height: 22))
        
        customCollectionView.layout(top: suggestedTitle.safeAreaLayoutGuide.bottomAnchor, leading: suggestedBackgroundView.safeAreaLayoutGuide.leadingAnchor, bottom: suggestedBackgroundView.safeAreaLayoutGuide.bottomAnchor, trailing: suggestedBackgroundView.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 5, left: 0, bottom: 0, right: 0))
    }
    
    //  MARK: - collectionView Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.response.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collCellId, for: indexPath) as! DetailCollectionViewCell
        cell.configure(viewModel.response.value[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let resultsId = viewModel.response.value[indexPath.row]
        resultsId.select()
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
        cell.backgroundColor = Constants.dynamicBackgroundColors
        let highlighedColor = UIView()
        highlighedColor.backgroundColor = .clear
        cell.selectedBackgroundView = highlighedColor
        
        cell.customTextView.text = listOfDataToShow[indexPath.row]
        cell.descriptionLabel.text = Constants.descriptionData[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerSecOne = UIView()
        headerSetUp(header: headerSecOne)
        sectionTwoHeader()
        return section == 0 ? headerSecOne : suggestedBackgroundView
    }
    
}

extension SerieDetail: Navigator {
    func navigate(to id: TVSeries) {
        let detailViewController = SerieDetail()
        detailViewController.tvSerieId = id
        
        if UIDevice.current.userInterfaceIdiom == .pad || Constants.deviceModelId.contains(UIDevice.current.modelName) && UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .landscapeLeft {
            let rootViewController = UINavigationController(rootViewController: detailViewController)
            showDetailViewController(rootViewController, sender: self)
        } else {
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
