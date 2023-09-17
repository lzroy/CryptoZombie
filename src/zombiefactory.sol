// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

//2. Create contract here
import "forge-std/console.sol";
import "./ownable.sol";
// console.log(message_valeur_ou_variable)

///// Contract 1: Zombie Factory
/////
contract ZombieFactory is Ownable{

    uint dnaDigits = 16;
    uint dnaModulus= 10 ** dnaDigits;
    uint cooldownTime = 1 days;

    // Definition of Zombie, Zombie array, NewZombie event, and address to ID mappings
    struct Zombie {
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime;
        uint16 winCount;
        uint16 lossCount;
    }

    Zombie[] public zombies;

    event NewZombie (uint zombieId, string name, uint dna);

    mapping (uint => address) public zombieToOwner; 
    mapping (address => uint) public ownerZombieCount;

    // Functions to: Generate random DNA, generate Zombie from DNA
    function _createZombie(string memory _name, uint _dna) internal {
        // console.log(zombies[0].name);
        // console.log(zombies[0].dna);
        uint id = zombies.length;
        zombies.push(Zombie(_name, _dna, 1 , uint32(block.timestamp + cooldownTime), 0, 0));
        emit NewZombie(id, _name, _dna);
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
    }

    function _generateRandomDna(string memory _str) private view returns (uint){
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}