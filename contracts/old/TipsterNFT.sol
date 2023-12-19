//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721Enumerable, Ownable {
    using SafeMath for uint256;
    using Strings for uint256;

    struct RoyaltyDistribution {
        address payable recipient;
        uint256 percentage;
    }
    string public baseURI;
    string public baseExtension = ".json";
    mapping(uint256 => uint256) internal _tokenTimestamp;
    mapping(uint256 => address) internal _tokenOwner;

    RoyaltyDistribution[] public royaltyDistributions;

    constructor(string memory _initBaseURI) ERC721("TipsterCollection", "TC") {
        setBaseURI(_initBaseURI);
        uint256 deadline = block.timestamp.add(block.timestamp);
        mint(1, deadline);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function getTokenTimestamp(uint256 _tokenId) public view returns (uint256) {
        return _tokenTimestamp[_tokenId];
    }

    function getTokenOwner(uint256 _tokenId) public view returns (address) {
        return _tokenOwner[_tokenId];
    }

    // Brucia l'NFT se non è più valido
    function burnIfInvalid(uint256 _tokenId) public {
        require(isValid(_tokenId), "NFT not valid");
        _burn(_tokenId);
    }

    function isValid(uint256 _tokenId) public view returns (bool) {
        uint256 validityPeriod = getTokenTimestamp(_tokenId);
        return block.timestamp <= validityPeriod;
    }

    function mint(uint256 _tokenId, uint256 _validityPeriod) public {
        require(_validityPeriod > block.timestamp, "Invalid validity period");
        //modificare _tokenId, introducendo totalSupply e tokenId incrementale.
        _mint(msg.sender, _tokenId);
        _setTokenMetadata(_tokenId, msg.sender, _validityPeriod);
    }

    function _setTokenMetadata(uint256 _tokenId, address owner, uint256 _timestamp) internal {
        require(_exists(_tokenId));
        _tokenTimestamp[_tokenId] = _timestamp;
        _tokenOwner[_tokenId] = owner;
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory currentBaseURI = _baseURI();
        return
            bytes(currentBaseURI).length > 0
                ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
                : "";
    }

    function distributeRoyalties(uint256 _royalties) public {
        require(_royalties > 0, "Le royalty devono essere maggiori di zero");
        uint256 totalPercentage = 0;
        for (uint i = 0; i < royaltyDistributions.length; i++) {
            totalPercentage += royaltyDistributions[i].percentage;
        }
        require(
            totalPercentage == 100,
            "La percentuale totale delle royalty deve essere pari a 100"
        );

        uint256 totalRoyalties = _royalties * 100;
        for (uint i = 0; i < royaltyDistributions.length; i++) {
            RoyaltyDistribution memory distribution = royaltyDistributions[i];
            uint256 share = (totalRoyalties * distribution.percentage) / 100;
            distribution.recipient.transfer(share);
        }
    }
}
