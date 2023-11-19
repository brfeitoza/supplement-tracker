// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract SupplementTracker {
    struct SupplementInfo {
        address owner;
        string name;
        string manufacturer;
        uint256 proteins;
        uint256 carbs;
        uint256 fats;
        string expiryDate;
    }

    struct SupplementSignature {
        address signer;
        bytes32 messageHash;
        bytes signature;
    }

    mapping(uint256 => SupplementInfo) public supplements;
    mapping(uint256 => SupplementSignature[]) public supplementsSignatures;
    mapping(uint256 => mapping(address => bool)) public authorizedSigners;

    uint256 public supplementsCount = 0;

    function setSignerAuthorization(
        uint256 _supplementId,
        address _signer,
        bool _authorization
    ) public {
        require(_supplementId < supplementsCount, "Supplement not found.");
        require(
            msg.sender == supplements[_supplementId].owner,
            "Only the owner can set the signer authorization."
        );

        authorizedSigners[_supplementId][_signer] = _authorization;
    }

    function isValidSignature(
        address _signer,
        bytes32 _messageHash,
        bytes memory _signature
    ) internal pure returns (bool) {
        require(_signer != address(0), "Invalid signer address");
        require(_signature.length == 65, "Invalid signature length");

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            r := mload(add(_signature, 32))
            s := mload(add(_signature, 64))
            v := byte(0, mload(add(_signature, 96)))
        }

        if (v < 27) {
            v += 27;
        }

        return ecrecover(_messageHash, v, r, s) == _signer;
    }

    function signSupplement(uint256 _supplementId, bytes memory _signature)
        public
    {
        require(_supplementId < supplementsCount, "Supplement not found.");
        require(
            isAuthorized(msg.sender, _supplementId),
            "Only authorized parties can sign the supplement."
        );

        SupplementInfo memory supplement = supplements[_supplementId];

        bytes32 messageHash = keccak256(
            abi.encodePacked(
                supplement.name,
                supplement.manufacturer,
                supplement.proteins,
                supplement.carbs,
                supplement.fats,
                supplement.expiryDate
            )
        );

        require(
            isValidSignature(msg.sender, messageHash, _signature),
            "Invalid signature"
        );

        SupplementSignature[] storage signatures = supplementsSignatures[
            _supplementId
        ];

        signatures.push(
            SupplementSignature(msg.sender, messageHash, _signature)
        );

        supplementsSignatures[_supplementId] = signatures;
    }

    function isAuthorized(address _signer, uint256 _supplementId)
        internal
        view
        returns (bool)
    {
        return authorizedSigners[_supplementId][_signer];
    }

    function addSupplement(
        string memory _name,
        string memory _manufacturer,
        uint256 _proteins,
        uint256 _carbs,
        uint256 _fats,
        string memory _expiryDate,
        bytes memory _ownerSignature
    ) public {
        supplements[supplementsCount] = SupplementInfo(
            msg.sender,
            _name,
            _manufacturer,
            _proteins,
            _carbs,
            _fats,
            _expiryDate
        );

        bytes32 messageHash = keccak256(
            abi.encodePacked(
                supplements[supplementsCount].name,
                supplements[supplementsCount].manufacturer,
                supplements[supplementsCount].proteins,
                supplements[supplementsCount].carbs,
                supplements[supplementsCount].fats,
                supplements[supplementsCount].expiryDate
            )
        );

        require(
            isValidSignature(msg.sender, messageHash, _ownerSignature),
            "Invalid signature"
        );

        SupplementSignature[] storage signatures = supplementsSignatures[
            supplementsCount
        ];

        signatures.push(
            SupplementSignature(msg.sender, messageHash, _ownerSignature)
        );

        supplementsCount++;
    }

    function getSupplementSignatures(uint256 _supplementId)
        public
        view
        returns (SupplementSignature[] memory)
    {
        return supplementsSignatures[_supplementId];
    }

    function getSupplementInfo(uint256 _supplementId)
        public
        view
        returns (SupplementInfo memory)
    {
        require(_supplementId < supplementsCount, "Supplement not found.");
        return supplements[_supplementId];
    }
}
