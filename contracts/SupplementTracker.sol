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

    function signSupplement(
        uint256 _supplementId,
        bytes memory _signature,
        bytes32 _messageHash
    ) public {
        require(_supplementId < supplementsCount, "Supplement not found.");
        require(
            isAuthorized(msg.sender, _supplementId),
            "Only authorized parties can sign the supplement."
        );

        SupplementSignature[] storage signatures = supplementsSignatures[
            _supplementId
        ];

        signatures.push(
            SupplementSignature(msg.sender, _messageHash, _signature)
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
        bytes memory _ownerSignature,
        bytes32 _messageHash
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

        SupplementSignature[] storage signatures = supplementsSignatures[
            supplementsCount
        ];

        signatures.push(
            SupplementSignature(msg.sender, _messageHash, _ownerSignature)
        );

        supplementsCount++;
    }

    function getSupplements() public view returns (SupplementInfo[] memory) {
        SupplementInfo[] memory supplementList = new SupplementInfo[](
            supplementsCount
        );
        for (uint256 i = 0; i < supplementsCount; i++) {
            supplementList[i] = supplements[i];
        }
        return supplementList;
    }

    function getSupplementSignatures(uint256 _supplementId)
        public
        view
        returns (SupplementSignature[] memory)
    {
        require(_supplementId < supplementsCount, "Supplement not found.");

        SupplementSignature[] memory allSignatures = supplementsSignatures[
            _supplementId
        ];
        uint256 numSignatures = allSignatures.length;

        SupplementSignature[] memory result = new SupplementSignature[](
            numSignatures
        );

        for (uint256 i = 0; i < numSignatures; i++) {
            result[i] = allSignatures[i];
        }

        return result;
    }
}
