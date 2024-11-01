//
//  ViewCode.swift
//  CustomTableView
//
//  Created by Arthur Sobrosa on 01/11/24.
//

import UIKit

extension UIView {
    /// ViewCode helper method to pin any view to the superview it's been added to
    func pinEdgesToSuperview() {
        guard let superview else { return }

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor),
            bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
        ])
    }
}
