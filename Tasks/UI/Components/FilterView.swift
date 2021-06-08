//
//  FilterView.swift
//  Tasks
//
//  Created by Adam Lingham on 07/06/2021.
//

import SwiftUI

extension String {
    static let generalFilterImageName = "general"
    static let medicationFilterImageName = "medication"
    static let hydrationFilterImageName = "hydration"
    static let nutritionFilterImageName = "nutrition"
}

struct FilterOptions: OptionSet {
    let rawValue: Int8

    static let general = Self(rawValue: 1)
    static let medication = Self(rawValue: 1 << 1)
    static let hydration = Self(rawValue: 1 << 2)
    static let nutrition = Self(rawValue: 1 << 3)
}

extension FilterOptions: Hashable {}

struct FilterView: View {
    @Binding var filterOptions: FilterOptions
    @State private var general = false
    @State private var medication = false
    @State private var hydration = false
    @State private var nutrition = false

    var body: some View {
        HStack {
            Spacer()

            let data = [
                (
                    imageName: String.generalFilterImageName,
                    binding: $general,
                    state: general,
                    filterOption: FilterOptions.general
                ),
                (
                    imageName: String.medicationFilterImageName,
                    binding: $medication,
                    state: medication,
                    filterOption: FilterOptions.medication
                ),
                (
                    imageName: String.hydrationFilterImageName,
                    binding: $hydration,
                    state: hydration,
                    filterOption: FilterOptions.hydration
                ),
                (
                    imageName: String.nutritionFilterImageName,
                    binding: $nutrition,
                    state: nutrition,
                    filterOption: FilterOptions.nutrition
                )
            ]

            ForEach(data, id: \.self.filterOption) { item in
                ToggleButton(imageName: item.imageName, isChecked: item.binding)
                    .padding([.leading, .trailing])
                    .onChange(of: item.state) {
                        if $0 {
                            filterOptions.insert(item.filterOption)
                        } else {
                            filterOptions.remove(item.filterOption)
                        }
                    }
            }

            Spacer()
        }
        .padding()
    }
}

struct FilterView_Previews: PreviewProvider {
    private struct Container: View {
        @State private var filterOptions: FilterOptions = []

        var body: some View {
            FilterView(filterOptions: $filterOptions)
        }
    }

    static var previews: some View {
        Container()
            .previewLayout(.sizeThatFits)
    }
}
