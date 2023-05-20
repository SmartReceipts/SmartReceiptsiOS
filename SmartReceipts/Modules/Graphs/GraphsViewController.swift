//
//  GraphsViewController.swift
//  SmartReceipts
//
//  Created Bogdan Evsenev on 04.04.2020.
//  Copyright © 2020 Will Baumann. All rights reserved.
//

import UIKit
import RxSwift
import Charts

class GraphsViewController: UIViewController, Storyboardable {
    var viewModel: GraphsViewModelProtocol!
    private let bag = DisposeBag()
    
    @IBOutlet private var barChartView: BarChart!
    @IBOutlet private var lineChartView: LineChart!
    @IBOutlet private var pieChartView: PieChart!
    @IBOutlet private var periodButton: UIButton!
    @IBOutlet private var modelButton: UIButton!
    @IBOutlet private var closeButton: UIBarButtonItem!
    @IBOutlet private var shareButton: UIBarButtonItem!
    @IBOutlet private var graphsTitle: UILabel!
    
    var activeChart: ChartProtocol?
    
    private var graphsInfoViewController: GraphsInfoViewController?
    
    private lazy var valueFormatter: ValueFormatter = {
        return DefaultValueFormatter(formatter: numberFormatter)
    }()
    
    private lazy var numberFormatter: NumberFormatter = {
        let locale = Locale.current as NSLocale
        let symbol = locale.displayName(forKey: .currencySymbol, value: viewModel.trip.defaultCurrency.code) ?? ""
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.negativeSuffix = " \(symbol)"
        numberFormatter.positiveSuffix = numberFormatter.negativeSuffix
        return numberFormatter
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        pieChartView.valueFormatter = valueFormatter
        barChartView.valueFormatter = valueFormatter
        lineChartView.valueFormatter = valueFormatter
        
        setupChartData()
        viewModel.moduleDidLoad()
        title = LocalizedString("report_info_graphs")
        periodButton.layer.cornerRadius = periodButton.bounds.height/2
        modelButton.layer.cornerRadius = modelButton.bounds.height/2
        graphsTitle.text = viewModel.trip.name
        bind()
        
        AnalyticsManager.sharedManager.record(event: Event.Graphs.GraphsShown)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureInfoViewIfNeeded()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func bind() {
        viewModel.period.map { $0.title }
            .bind(to: periodButton.rx.titleBinder())
            .disposed(by: bag)
        
        periodButton.rx.tap.map { .period }
            .bind(to: viewModel.routeObserver)
            .disposed(by: bag)
        
        modelButton.rx.tap.map { .model }
            .bind(to: viewModel.routeObserver)
            .disposed(by: bag)
        
        closeButton.rx.tap.map { .close }
            .bind(to: viewModel.routeObserver)
            .disposed(by: bag)
        
        shareButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.shareGraph()
            }).disposed(by: bag)
    }
    
    private func configureInfoViewIfNeeded() {
        guard let activeChart = activeChart, graphsInfoViewController == nil else { return }
        let infoHeight = view.bounds.height - (activeChart.bounds.height + activeChart.frame.origin.y)
        graphsInfoViewController = GraphsInfoViewController.create(maxHeight: infoHeight)
        addPullUpController(graphsInfoViewController!, initialStickyPointOffset: infoHeight, animated: false, completion: nil)
        setupChartData()
    }
    
    private func shareGraph() {
        AnalyticsManager.sharedManager.record(event: Event.Graphs.GraphsShare)
        
        guard let activeChart = activeChart else { return }
        let color = activeChart.backgroundColor
        activeChart.backgroundColor = .white
        let snapshot = activeChart.makeSnapshot()
        activeChart.backgroundColor = color
        
        guard let image = snapshot else { return }
        let shareVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(shareVC, animated: true, completion: nil)
    }
    
    private func setupChartData() {
        viewModel.dataSet
            .subscribe(onNext: { [weak self] dataSet in
                self?.modelButton.set(title: dataSet.title)
                self?.activateChart(dataSet: dataSet)
            }).disposed(by: bag)
    }
    
    private func activateChart(dataSet: ChartDataSetProtocol) {
        lineChartView.isHidden = true
        barChartView.isHidden = true
        pieChartView.isHidden = true
        
        switch dataSet.chartType {
        case .barChart:
            barChartView.isHidden = false
            activeChart = barChartView
        case .lineChart:
            lineChartView.isHidden = false
            activeChart = lineChartView
        case .pieChart:
            pieChartView.isHidden = false
            activeChart = pieChartView
        }
        
        guard let activeChart = activeChart else { return }
        activeChart.buildChart(dataSet: dataSet)
        
        let items = dataSet.entries.enumerated().map { index, entry -> GraphsInfoDataSource.Item in
            let title = dataSet.xLabels[index]
            let color = activeChart.color(at: index) ?? .violetMain
            let total = numberFormatter.string(from: NSNumber(value: entry.y)) ?? "NaN"
            return .init(title: title, total: total, color: color)
        }
    
        graphsInfoViewController?.dataSource = GraphsInfoDataSource(items: items)
    }
    
}

extension GraphsAssembly.PeriodSelection {
    var title: String {
        switch self {
        case .daily: return LocalizedString("graphs.period.day")
        case .weekly: return LocalizedString("graphs.period.week")
        case .monthly: return LocalizedString("graphs.period.month")
        case .report: return LocalizedString("report")
        }
    }
}
