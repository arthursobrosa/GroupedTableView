//
//  ViewController.swift
//  CustomTableView
//
//  Created by Arthur Sobrosa on 31/10/24.
//

import UIKit

class ViewController: UIViewController {
    static let defaultCellID = "defaultCellID"

    // MARK: - UI Properties

    private lazy var tableView: UITableView = {
        let tableView = UITableView()

        /// disable lines between rows cause this will be created by hand
        tableView.separatorStyle = .none

        /// set table's delegate and data source
        tableView.delegate = self
        tableView.dataSource = self

        /// register defaultCell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.defaultCellID)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupUI()
    }
}

// MARK: - UI Setup

extension ViewController {
    private func setupUI() {
        view.addSubview(tableView)
        tableView.pinEdgesToSuperview()
    }
}

// MARK: - TableView Delegate and DataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(getter: UIView.tintColor)) {
            /// cell initial config
            let cornerRadius: CGFloat = 15
            cell.backgroundColor = .clear
            cell.selectionStyle = .none

            /// layer and path initialization for border
            let layer = CAShapeLayer()
            let path = CGMutablePath()

            /// depending on the row, a line will drawn or not
            var addLine = false

            /// store cell's bounds but 10 points shorter at each side
            let bounds = cell.bounds.insetBy(dx: 10, dy: 0)

            /// if current row is the first and section only has one row
            if indexPath.row == 0 && tableView.numberOfRows(inSection: indexPath.section) == 1 {
                /// then add a rounded rectangle around its bounds
                path.addRoundedRect(in: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)

                /// if it's the first row but section has more than one row
            } else if indexPath.row == 0 {
                /// then create an arc at the top
                path.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
                path.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.minY), tangent2End: CGPoint(x: bounds.midX, y: bounds.minY), radius: cornerRadius)
                path.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.minY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
                path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))

                /// and a line will need to be created below this row
                addLine = true

                /// if it's the last row of a section with more than one row
            } else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
                /// then create an arc at the bottom
                path.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
                path.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY), radius: cornerRadius)
                path.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
                path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))

                /// if it's an inbetween row
            } else {
                /// then create two lines at the sides
                path.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
                path.addLine(to: CGPoint(x: bounds.minX, y: bounds.minY))
                path.move(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
                path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))

                /// and a line will also need to be created below this row
                addLine = true
            }

            /// create separator line for the rows that need to
            if addLine {
                let lineLayer = CALayer()
                let lineHeight: CGFloat = 1 / UIScreen.main.scale
                let offset = bounds.width / 25 /// little offset to imitate native line separator style
                lineLayer.frame = CGRect(x: bounds.minX + offset, y: bounds.height - lineHeight, width: bounds.width - offset, height: lineHeight)
                lineLayer.backgroundColor = tableView.separatorColor?.cgColor
                layer.addSublayer(lineLayer)

                /// guarantee separator layer colors are updated correctly both at light and dark mode
                registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (_: Self, _: UITraitCollection) in
                    lineLayer.backgroundColor = tableView.separatorColor?.cgColor
                }
            }

            /// border layer config
            layer.path = path
            layer.lineWidth = 1
            layer.strokeColor = UIColor.systemGray4.cgColor
            layer.fillColor = UIColor.systemBackground.cgColor

            /// guarantee border layer colors are updated correctly both at light and dark mode
            registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (_: Self, _: UITraitCollection) in
                layer.strokeColor = UIColor.systemGray4.cgColor
                layer.fillColor = UIColor.systemBackground.cgColor
            }

            /// create UIView with the same size of the cell and the created layers to it
            let backgroundView = UIView(frame: bounds)
            backgroundView.layer.insertSublayer(layer, at: 0)
            backgroundView.backgroundColor = .clear

            /// set new background view as cell's background view
            cell.backgroundView = backgroundView
        }
    }

    func numberOfSections(in _: UITableView) -> Int {
        3
    }

    func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Section \(section)"
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            5
        case 1:
            2
        case 2:
            1
        default:
            0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.defaultCellID, for: indexPath)
        cell.textLabel?.text = "Row \(indexPath.row)"
        return cell
    }
}
