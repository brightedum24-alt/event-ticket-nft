// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract EventTicketNFT is ERC721, Ownable {
    uint256 public ticketPriceETH;
    IERC20 public paymentToken;
    uint256 public tokenPrice;
    uint256 public maxPerWallet;
    uint256 public totalSupply;
    uint256 public maxSupply;

    uint256 private _tokenIdCounter;

    mapping(address => uint256) public mintedPerWallet;

    constructor(
        uint256 _ticketPriceETH,
        address _paymentToken,
        uint256 _tokenPrice,
        uint256 _maxPerWallet,
        uint256 _maxSupply
    ) ERC721("EventTicketNFT", "ETNFT") Ownable(msg.sender) {
        ticketPriceETH = _ticketPriceETH;
        paymentToken = IERC20(_paymentToken);
        tokenPrice = _tokenPrice;
        maxPerWallet = _maxPerWallet;
        maxSupply = _maxSupply;
    }

    function mintWithETH() external payable {
        require(msg.value >= ticketPriceETH, "Insufficient ETH");
        _mintTicket(msg.sender);
    }

    function mintWithToken() external {
        require(
            paymentToken.transferFrom(msg.sender, address(this), tokenPrice),
            "Token payment failed"
        );
        _mintTicket(msg.sender);
    }

    function _mintTicket(address to) internal {
        require(totalSupply < maxSupply, "Sold out");
        require(mintedPerWallet[to] < maxPerWallet, "Wallet limit reached");

        _tokenIdCounter++;
        _safeMint(to, _tokenIdCounter);

        mintedPerWallet[to]++;
        totalSupply++;
    }
}
