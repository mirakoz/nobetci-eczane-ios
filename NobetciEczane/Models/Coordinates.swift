import Foundation

struct Coordinates: Equatable {
    let latitude: Double
    let longitude: Double

    func distance(to other: Coordinates) -> Double {
        let R = 6371.0
        let dLat = (other.latitude - latitude) * .pi / 180
        let dLon = (other.longitude - longitude) * .pi / 180
        let a = sin(dLat/2) * sin(dLat/2) +
                cos(latitude * .pi / 180) * cos(other.latitude * .pi / 180) *
                sin(dLon/2) * sin(dLon/2)
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        return R * c
    }
}