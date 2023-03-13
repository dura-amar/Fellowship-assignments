//SPDX-License-Identifier:NONE

pragma solidity ^0.8.10;

contract ProofOfExistence1 {
    // state
    bytes32[] proofs;

    // calculate and store the proof for a document
    // *transactional function*

    /// @notice stores the proof for a document
    /// @dev pushes the hash of the given document to the array of proofs
    /// @param document string to be notarized
    function notarize(string memory document) public {
        proofs.push(_getHash(document));
    }

    // helper function to get a document's sha256
    // *read-only function*

    /// @notice calculates the hash of given string data
    /// @dev internal function to assist hash calculation
    /// @param _document string to be hashed
    /// @return bytes32 hash of the given string
    function _getHash(string memory _document) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_document));
    }

    /// @notice checks if a document has been notarized
    /// @dev loops through the array of proofs and checks if the given document's hash is present
    /// @param _document string to be checked
    /// @return bool true if the document has been notarized, false otherwise
    function checkDocument(string memory _document) public view returns (bool) {
        bytes32 proof = _getHash(_document);
        for (uint256 i = 0; i < proofs.length; i++) {
            if (proofs[i] == proof) {
                return true;
            }
        }
        return false;
    }
}
