//
//  DateFormatter.swift
//  BookShelf
//
//  Created by Ksenia on 18.11.2023.
//

import Foundation

let dateComponentsFormatter: DateComponentsFormatter = {
  let formatter = DateComponentsFormatter()
  formatter.allowedUnits = [.minute, .second]
  formatter.zeroFormattingBehavior = .pad
  return formatter
}()
