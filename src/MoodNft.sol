//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol" ;
import {Base64} from "lib/oppenzeppelin-contracts/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
     //errors 
     error MoodNft__CantFlipMoodIfNotOwner();

    uint256 private s_tokenCounter;
    string private s_sadSvgImageUri;
    string private s_happySvgImageUri;

    enum MOOD {
        HAPPY,
        SAD
    }
    
    mapping(uint256 => Mood) private s_tokenIdToMood;

    constructor(
        string memory sadSvgImageUri,
        string memory happySvgImageUri
    ) ERC721("Mood NFT", "MN"){
       s_tokenCounter = 0;
       s_sadSvg = sadSvgImageUri;
       s_happySvg = happySvgImageUri;
    }

    function mintNft() public {
        _safeMint(msg.sender,s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = MOOD.HAPPY;
        s_tokenCounter++;
    }

    function flipMood(uint256 tokenId) public {
        // only want the nft owner to change the mood
        if(!_isApprovedOrOwner(msg.sender, tokenId)){
            revert MoodNft__CantFlipMoodIfNotOwner();
        }
        if(s_tokenIdToMood[tokenId]== MOOD.HAPPY){
            s_tokenIdToMood[tokenId]== MOOD.SAD;
        } else {
            s_tokenIdToMood[tokenId]== MOOD.HAPPY;
        }
    }

    function _baseURI() internal pure override returns (string memory){
        return "data:application/json;base64";
    }

    function tokenURI(uint256 tokenId) public view override returns(string memory){

        string memory imageURI;
        if(s_tokenIdToMood[tokenId] == MOOD.HAPPY){
            imageURI = s_happySvgImageUri;
        } else {
            imageUri = s_sadSvgImageUri;
        }

      return string(
        abi.encodePacked(
            _baseURI(),
           Base64.encode(
       bytes(
       abi.encodePacked('{"name": "', name(), '", "description": "An NFT that reflects the owners mood.", "attributes":[{"trait_type": "moodiness", "value": 100}], "image": "', imageURI, '"}'),
            )
          ); 
        )
      )
    }
}