// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./zombiefactory.sol";
// console.log(message_valeur_ou_variable)

// Interface for CryptoKitties 
interface KittyInterface{
    function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
    );
}

///// Contract 2: Zombie Feeding
/////

contract ZombieFeeding is ZombieFactory{
    
    //// UTILITIES
    ///

    KittyInterface kittyContract;

    modifier onlyOwnerOf(uint _zombieId){
        require(msg.sender == zombieToOwner[_zombieId]);
        _;
    }

    // changes the Kitty contract address
    function setKittyContractAddress(address _address) external onlyOwner{
        kittyContract = KittyInterface(_address);
    }

    // adds 1 day to th zombie cooldown
    function _triggerCooldown(Zombie storage _zombie) internal {
        _zombie.readyTime = uint32(block.timestamp + cooldownTime);
    }

    // check if a zombie's cooldown is up
    function _isReady(Zombie storage _zombie) internal view returns (bool){
        return(_zombie.readyTime <= block.timestamp);
    }

    //// FEEDING
    ///
    
    function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) internal onlyOwnerOf(_zombieId){
        // retrieve zombie
        Zombie storage myZombie = zombies[_zombieId];
        // chech that feeding cooldown is down
        require(_isReady(myZombie));

        // create modifyed dna 
        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myZombie.dna + _targetDna) / 2;
        if(keccak256(abi.encode(_species)) == keccak256(abi.encode("kitty"))){
            newDna = newDna - newDna % 100 + 99;}
        // create the newly infected zombie
        _createZombie("NoName", newDna);
        _triggerCooldown(myZombie);
    }

    function feedOnKitty(uint _zombieId, uint _kittyId) public{
        uint kittyDna;
        // retrieves a kitty dna 
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
        // feed on a kitty
        feedAndMultiply(_zombieId, kittyDna, "kitty");   
    }
}