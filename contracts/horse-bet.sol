// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
import "hardhat/console.sol";
import "./abstracts/i_betting.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
contract HorseRaceBetting is IBetting{

    function addNewHorse(string memory horseName) public returns (bool){
        bool isHorseAdded = addHorse(horseName);
        return isHorseAdded;
    }

    function addNewJockey(string memory jockeyName) public returns (bool){
        bool isJockeyAdded = addJockey(jockeyName);
        return isJockeyAdded;
    }

    function getHorses() public view returns (Horse []memory){
        return horses;
    }

    function getJockeys() public view returns (Jockey []memory){
        return jockeys;
    }

    function createRace(string memory locationId,
        uint[] memory participatingHorses,
        uint[] memory participatingJockeys) public {
        Location location;
        if(keccak256(bytes(locationId)) == keccak256("northamerica")){
            location = Location.NorthAmerica;
        }else if(keccak256(bytes(locationId)) == keccak256("europe")){
            location = Location.Europe;
        }else if(keccak256(bytes(locationId)) == keccak256("australia")){
            location = Location.Australia;
        }else if(keccak256(bytes(locationId)) == keccak256("asia")){
            location = Location.Asia;
        }
        createNewRace(location, participatingHorses, participatingJockeys);
    }

    function cancelRace(uint raceId) public {
        refundRemoveBets(raceId);
        cancelHorseRace(raceId);
    }

    function placeNewBet(string memory betType, uint raceId, uint userId, uint horseId) payable public {
        BetType newBetType;
        if(keccak256(bytes(betType)) == keccak256("win")){
            newBetType = BetType.Win;
        }else if(keccak256(bytes(betType)) == keccak256("place")){
            newBetType = BetType.Place;
        }else if(keccak256(bytes(betType)) == keccak256("show")){
            newBetType = BetType.Show;
        }
        placeBet(newBetType, raceId, userId, horseId);
    }

    function performRace(uint raceId) public {
        startHorseRace(raceId);
        verifyBetWinsAndSettleCash(raceId);
    }
}
