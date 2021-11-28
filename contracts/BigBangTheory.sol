// contracts/DungeonsAndDragonsCharacter.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract BigBangTheory is ERC721URIStorage, VRFConsumerBase, Ownable {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  bytes32 internal keyHash;
  uint256 internal fee;
  uint256 public randomResult;
  address public VRFCoordinator;
  address public LinkToken;
  uint256 public sheldonCount;
  uint256 public pennyCount;
  string chooseOneCharacter;

  struct BBTCharacterAttributes {
    uint256 emphatic;
    uint256 toleration;
    uint256 Nerdy;
    uint256 SocialSkills;
    uint256 Extrovert;
    uint256 organized;
    string name;
  }

  BBTCharacterAttributes[] public characters;

  mapping(bytes32 => string) public requestToCharacterName;
  mapping(bytes32 => address) requestToSender;
  mapping(bytes32 => uint256) requestToTokenId;

  event result(string, uint256);

  event requestedCharacter(bytes32 indexed requestId);

  /**
   * Constructor inherits VRFConsumerBase
   *
   * Network: Rinkeby
   * Chainlink VRF Coordinator address: 0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B
   * LINK token address:                0x01BE23585060835E02B77ef475b0Cc51aA1e0709
   * Key Hash: 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311
   */
  constructor(
    address _VRFCoordinator,
    address _LinkToken,
    bytes32 _keyhash,
    string memory _chooseOneCharacter
  )
    public
    VRFConsumerBase(_VRFCoordinator, _LinkToken)
    ERC721("BigBangTheory", "BBT")
  {
    VRFCoordinator = _VRFCoordinator;
    LinkToken = _LinkToken;
    keyHash = _keyhash;
    fee = 0.1 * 10**18; // 0.1 LINK
    chooseOneCharacter = _chooseOneCharacter;
  }

  function requestCharacterAttributes() public returns (bytes32) {
    require(
      LINK.balanceOf(address(this)) >= fee,
      "Not enough LINK - fill contract with faucet"
    );
    bytes32 requestId = requestRandomness(keyHash, fee);

    requestToSender[requestId] = msg.sender;
    emit requestedCharacter(requestId);
    return requestId;
  }

  function getNumberOfCharacters() public view returns (uint256) {
    return characters.length;
  }

  function getTokenURI(uint256 tokenId) public view returns (string memory) {
    return tokenURI(tokenId);
  }

  function setTokenURI(uint256 tokenId, string memory _tokenURI) public {
    require(
      _isApprovedOrOwner(_msgSender(), tokenId),
      "ERC721: transfer caller is not owner nor approved"
    );
    _setTokenURI(tokenId, _tokenURI);
  }

  function fulfillRandomness(bytes32 requestId, uint256 randomNumber)
    internal
    override
  {
    uint256 newItemId = _tokenIds.current();
    string[] memory arr = new string[](2);
    arr[0] = "Penny";
    arr[1] = "Sheldon";

    string memory characterName;
    for (uint256 i = 0; i < arr.length; i++) {
      characterName = arr[i];
    }
    uint256 emphatic = randomNumber % 100;
    uint256 toleration = uint256(keccak256(abi.encode(randomNumber, 1))) % 100;
    uint256 Nerdy = uint256(keccak256(abi.encode(randomNumber, 2))) % 100;
    uint256 SocialSkills = uint256(keccak256(abi.encode(randomNumber, 3))) %
      100;
    uint256 Extrovert = uint256(keccak256(abi.encode(randomNumber, 4))) % 100;
    uint256 organized = uint256(keccak256(abi.encode(randomNumber, 5))) % 100;
    BBTCharacterAttributes memory character = BBTCharacterAttributes(
      emphatic,
      toleration,
      Nerdy,
      SocialSkills,
      Extrovert,
      organized,
      characterName
    );
    characters.push(character);

    _safeMint(requestToSender[requestId], newItemId);
    _tokenIds.increment();
  }

  function sheldonVSpenny() public {
    if (characters[0].emphatic > characters[1].emphatic) {
      pennyCount++;
    } else {
      sheldonCount++;
    }
    if (characters[0].toleration > characters[1].toleration) {
      pennyCount++;
    } else {
      sheldonCount++;
    }
    if (characters[0].Nerdy > characters[1].Nerdy) {
      sheldonCount++;
    } else {
      pennyCount++;
    }
    if (characters[0].SocialSkills > characters[1].SocialSkills) {
      pennyCount++;
    } else {
      sheldonCount++;
    }
    if (characters[0].Extrovert > characters[1].Extrovert) {
      pennyCount++;
    } else {
      sheldonCount++;
    }
    if (characters[0].organized > characters[1].organized) {
      sheldonCount++;
    } else {
      pennyCount++;
    }
  }

  function findResult() public {
    if (pennyCount == sheldonCount) {
      emit result("IT'S A TIE", pennyCount);
      return;
    }
    if (
      keccak256(abi.encodePacked(chooseOneCharacter)) ==
      keccak256(abi.encodePacked("penny"))
    ) {
      if (pennyCount > sheldonCount) {
        emit result("Chosen penny:YOU ARE THE WINNER", pennyCount);
      } else {
        emit result("Chosen penny:YOU LOOSE", pennyCount);
      }
      return;
    }
    if (
      keccak256(abi.encodePacked(chooseOneCharacter)) ==
      keccak256(abi.encodePacked("sheldon"))
    ) {
      if (pennyCount < sheldonCount) {
        emit result("Chosen sheldon:YOU ARE THE WINNER", sheldonCount);
      } else {
        emit result("Chosen sheldon:YOU Loose", sheldonCount);
      }
      return;
    }
  }
}
