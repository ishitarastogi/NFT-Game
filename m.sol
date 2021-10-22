// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTMint is ERC721, Ownable {
    uint256 counter;
uint256 fee=0.001 ether;
    constructor() ERC721("MyCollectible", "MCO") {}

    struct Lip {
        string name;
        uint256 id;
        uint256 dna;
        uint8 level;
        uint8 rarity;
    }
    Lip[] public lips;
    
    event NewLip(address indexed owner, uint256 id, uint256 dna );
    
    
    function _createRandomNum(uint256 _mod) internal view returns(uint256){
        uint256 randomNum=uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender)));
        return randomNum % _mod;
    }
    
    function updateFee(uint256 _fee) external onlyOwner{
        fee=_fee;
    }

    function _createNFT(string memory _name) internal  {
            uint256 randDna=_createRandomNum(10**16);

        uint8 randRarity= uint8(_createRandomNum(100));
        Lip memory newLip = Lip(_name, counter, randDna, 1, randRarity);
        lips.push(newLip);

        _safeMint(msg.sender, counter);
        emit NewLip(msg.sender, counter, randDna);
        counter++;
    }
    
    function createRandomLip(string memory _name) public payable{ 
        
        require(msg.value==fee,"not enough");
        
        _createNFT(_name); 
    }
    function getBalance() public  view returns(uint256) {
        return(address(this).balance);
    }
    function getLips() public view returns(Lip[] memory){
        return lips;
    }
}
