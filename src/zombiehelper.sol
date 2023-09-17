// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding{

    uint levelUpFee = 0.001 ether;

    function setLevelUpFee(uint _fee) external onlyOwner{
        levelUpFee = _fee;
    }

    modifier aboveLevel(uint _level, uint _zombieId){
        require(zombies[_zombieId].level >= _level);
        _;
    }   
                                   

    function withdraw() external onlyOwner{
        address payable _owner = payable(owner());
        _owner.transfer(address(this).balance);
    }

    function getZombiesByOwner(address _owner) external view returns (uint[] memory){
        
        // prepare an array with the size for owner's zombies
        uint[] memory result = new uint[](ownerZombieCount[_owner]);
        uint counter = 0;

        // retrieve owner's zombies
        for (uint i = 0; i < zombies.length; i++){
            if (zombieToOwner[i] == _owner){
                result[counter] = i;
                counter++;
                }
        }
        return result;
    }

    function levelUp(uint _zombieId) external payable{
        require(msg.value == levelUpFee);
        zombies[_zombieId].level++;
    }

    function changeName(uint _zombieId, string calldata _newName) external onlyOwnerOf(_zombieId) aboveLevel(2, _zombieId){
        zombies[_zombieId].name = _newName;
    }


    function changeDna(uint _zombieId, uint _newDna) external onlyOwnerOf(_zombieId) aboveLevel(20, _zombieId){
        zombies[_zombieId].dna = _newDna;
    }
}
