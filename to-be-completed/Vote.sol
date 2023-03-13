//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/// @author dura.eth
/// @title Vote for your favorite city
/// @notice You can vote for your favorite city
contract cityPoll {
    struct City {
        string cityName;
        uint256 vote;
        //you can add city details if you want
    }

    mapping(uint256 => City) public cities; //mapping city Id with the City struct - cityId should be uint256
    mapping(address => bool) hasVoted; //mapping to check if the address/account has voted or not

    address owner;
    uint256 public cityCount = 0; // number of city added

    /// @dev constructor to set the owner and add some initial cities
    constructor() {
        // set the owner of the contract
        owner = msg.sender;

        // add some initial cities
        cityCount++;
        cities[cityCount] = City("Kathmandu", 0);
        cityCount++;
        cities[cityCount] = City("Pokhara", 0);
    }

    /// @dev add city to the cities mapping
    /// @param _cityName name of the city
    function addCity(string memory _cityName) public {
        //  TODO: add city to the CityStruct
        require(msg.sender == owner, "You are not the owner");
        cityCount++;
        cities[cityCount] = City(_cityName, 0);
        
    }

    /// @dev vote for the city
    /// @param _cityId id of the city to vote
    function voteCity(uint256 _cityId) public {
        require(!hasVoted[msg.sender], "You have already voted");

        //TODO Vote the selected city through cityID
        City memory ct = cities[_cityId];
        ct.vote++;
        cities[_cityId] = ct;
        hasVoted[msg.sender] = true;
    }

    /// @dev get the city details
    /// @param _cityId id of the city
    /// @return cityName of the city
    function getCity(uint256 _cityId) public view returns (string memory) {
        // TODO get the city details through cityID
        City memory ct = cities[_cityId];
        return ct.cityName;
    }

    /// @dev get the vote of the city
    /// @param _cityId id of the city
    /// @return vote of the city
    function getVote(uint256 _cityId) public view returns (uint256) {
        // TODO get the vote of the city with its ID
        City memory ct = cities[_cityId];
        return ct.vote;
    }

    receive() external payable {}

    fallback() external payable {}
}
