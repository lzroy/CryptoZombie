// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./erc721.sol";
import "./zombieattack.sol";

contract ZombieOwnership is ZombieAttack, ERC721{

    mapping(uint256=>address) zombieApprovals;

    function balanceOf(address _owner) external view returns (uint256) {
        return(ownerZombieCount[_owner]);
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        return(zombieToOwner[_tokenId]);
    }

    function _transfer(address _from, address _to, uint256 _tokenId) private{
            ownerZombieCount[_to]++;
            ownerZombieCount[_from]--;
            zombieToOwner[_tokenId] = _to;
            emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
        require(zombieToOwner[_tokenId] == msg.sender || zombieApprovals[_tokenId] == msg.sender);
        _transfer(_from, _to, _tokenId);
        return();
    }

    function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId){
        zombieApprovals[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }
}