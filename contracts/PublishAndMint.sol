
//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";



contract Publisher is ERC721URIStorage {

    using Counters for Counters.Counter;

    struct Publication {
        string title;
        string authors;
        string description;
        string tokenURI;
        uint256 tokenID;
    }

    mapping(address => Publication[]) public publications;
    mapping(address => uint) public pubCounts;
    address[] public correspondingAuthors;
    uint public authorCount;

    Counters.Counter private _tokenIDs;


    constructor() ERC721("PublishBaseNFT", "PUB") {}


    event NewPublicationEvent (
        address indexed _sender,
        uint256 indexed _newID,
        string indexed _tokenURI
    );


    function publish(
        string memory _title,
        string memory _authors,
        string memory _description,
        string memory _tokenURI
    ) public returns (uint256) {

        // create new token ID for the NFT
        _tokenIDs.increment();
        uint256 newID = _tokenIDs.current();

        // mint the NFT
        _mint(msg.sender, newID);
        _setTokenURI(newID, _tokenURI);

        Publication memory pub = Publication({
            title: _title,
            authors: _authors,
            description: _description,
            tokenURI: _tokenURI,
            tokenID: newID
        });
        
        
        // if this address has never published before
        // add it to the correponding authors list
        if (publications[msg.sender].length == 0){
            correspondingAuthors.push(msg.sender);
            authorCount += 1;
        }

        pubCounts[msg.sender] += 1;
        publications[msg.sender].push(pub);


        emit NewPublicationEvent(msg.sender, newID, _tokenURI);

        return newID;
    }

}
