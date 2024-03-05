//
//  MovieError.swift
//  MovieList
//
//  Created by Shivani Agarwal on 29/02/24.
//

import Foundation

enum MovieError: Error {
    case INVALID_DATA
    case UNABLE_TO_DECODE
    case UNABLE_TO_CREATE_IMAGE
    case REQUEST_FAILED(Error)
    case INVALID_URL
    case INVALID_RESPONSE
}
