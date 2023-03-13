//SPDX-License-Identifier:NONE

pragma solidity ^0.8.0;


contract ProofOfExistence {
      
      mapping(bytes32 => address) storedBy;
      mapping(bytes32 => uint256) storedOn;
      
      
      struct doc {
          address storedBy;
          uint256 storedOn;
      }

        mapping(bytes32 => doc) docs;
      // calculate and store the proof for a document
      // *transactional function*
      function notarize(string memory _document) public {
        bytes32 proof = findHash(_document);
        docs[proof].storedBy = msg.sender;
        docs[proof].storedOn= block.timestamp;
      }

      // helper function to get a document's sha256
      // *read-only function*
      ///@notice calculates the hash of given string data
	///@dev internal function to assist hash calculation
	function findHash(string memory _data) private pure returns (bytes32) {
		return keccak256(abi.encodePacked(_data));
	}
      
      
      function getStorer(string memory _document) public view returns (address){
            bytes32 proof = findHash(_document);
            return docs[proof].storedBy;
      }
      
      
      function getDoc(string memory _document) public view returns(address,uint256){
          bytes32 proof = findHash(_document);
          return (docs[proof].storedBy,docs[proof].storedOn);
      }
      

}
