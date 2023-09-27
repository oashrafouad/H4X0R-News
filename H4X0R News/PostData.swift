//
//  PostData.swift
//  H4X0R News
//
//  Created by Omar Ashraf on 09/09/2023.
//

import Foundation

struct PostData: Codable
{
    let title: String
    let score: Int
    let url: URL?
}
