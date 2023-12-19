// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract fantavolleySFT is ERC1155Supply, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;
    Counters.Counter private _tokenIdCounter;
    string public baseURI;
    string public baseExtension = ".json";
    string public name;
    string public symbol;

    constructor(string memory _name, string memory _symbol, string memory _uri) ERC1155(_uri) {
        name = _name;
        symbol = _symbol;
        setBaseURI(_uri);
        mintSemiFungible(msg.sender, 10, 170);
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
        baseExtension = _newBaseExtension;
    }

    function uri(uint256 tokenId) public view virtual override returns (string memory) {
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, tokenId.toString(), baseExtension))
                : "";
    }

    function mintSemiFungible(address _to, uint256 _copies, uint256 _mintAmount) public onlyOwner {
        require(_mintAmount > 0);
        for (uint256 i = 0; i < _mintAmount; i++) {
            _tokenIdCounter.increment();
            uint256 newTokenId = _tokenIdCounter.current();
            _mint(_to, newTokenId, _copies, "");
        }
    }

    function burnSemiFungible(address _account, uint256 _tokenId, uint256 _copies) public {
        require(_isApprovedOrOwner(_msgSender(), _tokenId), "Caller is not owner nor approved");
        _burn(_account, _tokenId, _copies);
    }

    function _isApprovedOrOwner(
        address spender,
        uint256 tokenId
    ) internal view virtual returns (bool) {
        address owner = ownerOf(tokenId);
        return (spender == owner || isApprovedForAll(owner, spender));
    }

    function ownerOf(uint256 tokenId) public view virtual returns (address) {
        return balanceOf(msg.sender, tokenId) > 0 ? msg.sender : address(0);
    }
}
