//
//  State.swift
//  Statehood
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Nikolai Vazquez
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

private let _abbreviations = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA",
                              "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD",
                              "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ",
                              "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC",
                              "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]

private let _capitals = ["Montgomery",    "Juneau",    "Phoenix",     "Little Rock",    "Sacramento",
                         "Denver",        "Hartford",  "Dover",       "Tallahassee",    "Atlanta",
                         "Honolulu",      "Boise",     "Springfield", "Indianapolis",   "Des Moines",
                         "Topeka",        "Frankfort", "Baton Rouge", "Augusta",        "Annapolis",
                         "Boston",        "Lansing",   "St. Paul",    "Jackson",        "Jefferson City",
                         "Helena",        "Lincoln",   "Carson City", "Concord",        "Trenton",
                         "Santa Fe",      "Albany",    "Raleigh",     "Bismarck",       "Columbus",
                         "Oklahoma City", "Salem",     "Harrisburg",  "Providence",     "Columbia",
                         "Pierre",        "Nashville", "Austin",      "Salt Lake City", "Montpelier",
                         "Richmond",      "Olympia",   "Charleston",  "Madison",        "Cheyenne"]

private let _abbreviationsToStates: [String: States] = {
    var result = [String: States]()
    for state in States.all {
        result[state.abbreviation] = state
    }
    return result
}()

/// A U.S. state.
public enum States: String, CustomStringConvertible, CaseIterable {
    
    #if swift(>=3)
    
    /// Alabama.
    case alabama = "Alabama"
    
    /// Alaska.
    case alaska = "Alaska"
    
    /// Arizona.
    case arizona = "Arizona"
    
    /// Arkansas.
    case arkansas = "Arkansas"
    
    /// California.
    case california = "California"
    
    /// Colorado.
    case colorado = "Colorado"
    
    /// Connecticut.
    case connecticut = "Connecticut"
    
    /// Delaware.
    case delaware = "Delaware"
    
    /// Florida.
    case florida = "Florida"
    
    /// Georgia.
    case georgia = "Georgia"
    
    /// Hawaii.
    case hawaii = "Hawaii"
    
    /// Idaho.
    case idaho = "Idaho"
    
    /// Illinois.
    case illinois = "Illinois"
    
    /// Indiana.
    case indiana = "Indiana"
    
    /// Iowa.
    case iowa = "Iowa"
    
    /// Kansas.
    case kansas = "Kansas"
    
    /// Kentucky.
    case kentucky = "Kentucky"
    
    /// Louisiana.
    case louisiana = "Louisiana"
    
    /// Maine.
    case maine = "Maine"
    
    /// Maryland.
    case maryland = "Maryland"
    
    /// Massachusetts.
    case massachusetts = "Massachusetts"
    
    /// Michigan.
    case michigan = "Michigan"
    
    /// Minnesota.
    case minnesota = "Minnesota"
    
    /// Mississippi.
    case mississippi = "Mississippi"
    
    /// Missouri.
    case missouri = "Missouri"
    
    /// Montana.
    case montana = "Montana"
    
    /// Nebraska.
    case nebraska = "Nebraska"
    
    /// Nevada.
    case nevada = "Nevada"
    
    /// New Hampshire.
    case newHampshire = "New Hampshire"
    
    /// New Jersey.
    case newJersey = "New Jersey"
    
    /// New Mexico.
    case newMexico = "New Mexico"
    
    /// New York.
    case newYork = "New York"
    
    /// North Carolina.
    case northCarolina = "North Carolina"
    
    /// North Dakota.
    case northDakota = "North Dakota"
    
    /// Ohio.
    case ohio = "Ohio"
    
    /// Oklahoma.
    case oklahoma = "Oklahoma"
    
    /// Oregon.
    case oregon = "Oregon"
    
    /// Pennsylvania.
    case pennsylvania = "Pennsylvania"
    
    /// Rhode Island.
    case rhodeIsland = "Rhode Island"
    
    /// South Carolina.
    case southCarolina = "South Carolina"
    
    /// South Dakota.
    case southDakota = "South Dakota"
    
    /// Tennessee.
    case tennessee = "Tennessee"
    
    /// Texas.
    case texas = "Texas"
    
    /// Utah.
    case utah = "Utah"
    
    /// Vermont.
    case vermont = "Vermont"
    
    /// Virginia.
    case virginia = "Virginia"
    
    /// Washington.
    case washington = "Washington"
    
    /// West Virginia.
    case westVirginia = "West Virginia"
    
    /// Wisconsin.
    case wisconsin = "Wisconsin"
    
    /// Wyoming.
    case wyoming = "Wyoming"
    
    /// All states.
    public static let all = [alabama, alaska, arizona, arkansas, california,
                             colorado, connecticut, delaware, florida, georgia,
                             hawaii, idaho, illinois, indiana, iowa,
                             kansas, kentucky, louisiana, maine, maryland,
                             massachusetts, michigan, minnesota, mississippi, missouri,
                             montana, nebraska, nevada, newHampshire, newJersey,
                             newMexico, newYork, northCarolina, northDakota, ohio,
                             oklahoma, oregon, pennsylvania, rhodeIsland, southCarolina,
                             southDakota, tennessee, texas, utah, vermont,
                             virginia, washington, westVirginia, wisconsin, wyoming]
    
    #else
    
    /// Alabama.
    case Alabama = "Alabama"
    
    /// Alaska.
    case Alaska = "Alaska"
    
    /// Arizona.
    case Arizona = "Arizona"
    
    /// Arkansas.
    case Arkansas = "Arkansas"
    
    /// California.
    case California = "California"
    
    /// Colorado.
    case Colorado = "Colorado"
    
    /// Connecticut.
    case Connecticut = "Connecticut"
    
    /// Delaware.
    case Delaware = "Delaware"
    
    /// Florida.
    case Florida = "Florida"
    
    /// Georgia.
    case Georgia = "Georgia"
    
    /// Hawaii.
    case Hawaii = "Hawaii"
    
    /// Idaho.
    case Idaho = "Idaho"
    
    /// Illinois.
    case Illinois = "Illinois"
    
    /// Indiana.
    case Indiana = "Indiana"
    
    /// Iowa.
    case Iowa = "Iowa"
    
    /// Kansas.
    case Kansas = "Kansas"
    
    /// Kentucky.
    case Kentucky = "Kentucky"
    
    /// Louisiana.
    case Louisiana = "Louisiana"
    
    /// Maine.
    case Maine = "Maine"
    
    /// Maryland.
    case Maryland = "Maryland"
    
    /// Massachusetts.
    case Massachusetts = "Massachusetts"
    
    /// Michigan.
    case Michigan = "Michigan"
    
    /// Minnesota.
    case Minnesota = "Minnesota"
    
    /// Mississippi.
    case Mississippi = "Mississippi"
    
    /// Missouri.
    case Missouri = "Missouri"
    
    /// Montana.
    case Montana = "Montana"
    
    /// Nebraska.
    case Nebraska = "Nebraska"
    
    /// Nevada.
    case Nevada = "Nevada"
    
    /// New Hampshire.
    case NewHampshire = "New Hampshire"
    
    /// New Jersey.
    case NewJersey = "New Jersey"
    
    /// New Mexico.
    case NewMexico = "New Mexico"
    
    /// New York.
    case NewYork = "New York"
    
    /// North Carolina.
    case NorthCarolina = "North Carolina"
    
    /// North Dakota.
    case NorthDakota = "North Dakota"
    
    /// Ohio.
    case Ohio = "Ohio"
    
    /// Oklahoma.
    case Oklahoma = "Oklahoma"
    
    /// Oregon.
    case Oregon = "Oregon"
    
    /// Pennsylvania.
    case Pennsylvania = "Pennsylvania"
    
    /// Rhode Island.
    case RhodeIsland = "Rhode Island"
    
    /// South Carolina.
    case SouthCarolina = "South Carolina"
    
    /// South Dakota.
    case SouthDakota = "South Dakota"
    
    /// Tennessee.
    case Tennessee = "Tennessee"
    
    /// Texas.
    case Texas = "Texas"
    
    /// Utah.
    case Utah = "Utah"
    
    /// Vermont.
    case Vermont = "Vermont"
    
    /// Virginia.
    case Virginia = "Virginia"
    
    /// Washington.
    case Washington = "Washington"
    
    /// West Virginia.
    case WestVirginia = "West Virginia"
    
    /// Wisconsin.
    case Wisconsin = "Wisconsin"
    
    /// Wyoming.
    case Wyoming = "Wyoming"
    
    /// All states.
    public static let all = [Alabama, Alaska, Arizona, Arkansas, California,
    Colorado, Connecticut, Delaware, Florida, Georgia,
    Hawaii, Idaho, Illinois, Indiana, Iowa,
    Kansas, Kentucky, Louisiana, Maine, Maryland,
    Massachusetts, Michigan, Minnesota, Mississippi, Missouri,
    Montana, Nebraska, Nevada, NewHampshire, NewJersey,
    NewMexico, NewYork, NorthCarolina, NorthDakota, Ohio,
    Oklahoma, Oregon, Pennsylvania, RhodeIsland, SouthCarolina,
    SouthDakota, Tennessee, Texas, Utah, Vermont,
    Virginia, Washington, WestVirginia, Wisconsin, Wyoming]
    
    #endif
    
    /// The abbreviation for `self`.
    public var abbreviation: String {
        return _abbreviations[hashValue]
    }
    
    /// The capital for `self`.
    public var capital: String {
        print(hashValue)
        return _capitals[hashValue]
    }
    
    /// A textual representation of this instance.
    public var description: String {
        return rawValue
    }
    
    /// Creates a state from a case-insensitive abbreviation.
    public init?(abbreviation: String) {
        guard abbreviation.count == 2 else {
//        guard abbreviation.characters.count == 2 else {
            return nil
        }
        #if swift(>=3)
            let key = abbreviation.uppercased()
        #else
            let key = abbreviation.uppercaseString
        #endif
        guard let state = _abbreviationsToStates[key] else {
            return nil
        }
        self = state
    }
    
}
