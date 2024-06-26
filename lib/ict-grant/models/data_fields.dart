enum ICTDataField{
  rid,
  id,
  firstName,
  lastName,
  dob,
  gender,
  phone,
  phoneNumber,
  email,
  nin,
  bvn,
  idDocument,
  ownerPassportPhotoUrl,
  address,
  homeAddress,
  isCivilServant,
  civilServant,
  businessName,
  businessAddress,
  businessLGA,
  businessLGACode,
  businessWard,
  businessRegCat,
  businessRegIssuer,
  businessRegNo,
  businessRegNum,
  ownerAtBusinessPhotoUrl,
  yearsInOperation,
  numStaff,
  ictProcCat,
  complPurchases,
  complPurchase1,
  complPurchase2,
  complPurchase3,
  ictToBeProcured,
  salaryRenum,
  costOfItems,
  costOfIntendedIct,
  accountName,
  bank,
  accountNumber,
  tax,
  tin,
  taxRegNum,
  taxIssuer,
  longitude,
  latitude,
  dataType,
  syncStatus,
  dataComplete,
  serverVerified,
  syncErrorMessage,

  idDocType,
  idDocPhotoUrl,

  taxId,
  issuer,
  taxRegPhotoUrl,

  catType,
  certPhotoUrl,
  cacProofDocPhotoUrl,

  itemsPurchased,

  itemsList,
  receiptPhotoUrl,

  groupPhotoUrl,
  renumerationPhotoUrl,
  comment,

  createdAt,
  updatedAt,
}

List<ICTDataField> ictFieldsForNewRecords = [
  ICTDataField.rid,
  ICTDataField.firstName,
  ICTDataField.lastName,
  ICTDataField.dob,
  ICTDataField.gender,
  ICTDataField.phone,
  ICTDataField.bvn,
  ICTDataField.nin,

  ICTDataField.idDocType,
  ICTDataField.idDocPhotoUrl,

  ICTDataField.email,
  ICTDataField.ownerPassportPhotoUrl,
  ICTDataField.homeAddress,
  ICTDataField.civilServant,
  ICTDataField.businessName,
  ICTDataField.businessAddress,
  ICTDataField.businessLGA,
  ICTDataField.businessLGACode,
  ICTDataField.businessWard,

  ICTDataField.catType,
  ICTDataField.certPhotoUrl,
  ICTDataField.cacProofDocPhotoUrl,

  ICTDataField.businessRegIssuer, //should be part of above schema
  ICTDataField.businessRegNum,
  ICTDataField.ownerAtBusinessPhotoUrl,
  ICTDataField.latitude,
  ICTDataField.longitude,
  ICTDataField.yearsInOperation,
  ICTDataField.numStaff,
  ICTDataField.ictProcCat,

  // ICTDataField.itemsPurchased,// parent, but array of:
  // ICTDataField.itemsList,
  // ICTDataField.receiptPhotoUrl,

  // ICTDataField.salaryRenum,//parent
  ICTDataField.groupPhotoUrl,
  ICTDataField.renumerationPhotoUrl,
  ICTDataField.comment,

  // ICTDataField.costOfItems,
  ICTDataField.bank,
  ICTDataField.accountNumber,
  ICTDataField.accountName,

  // ICTDataField.tax,//parent
  ICTDataField.taxId,
  ICTDataField.issuer,
  ICTDataField.taxRegPhotoUrl,

  ICTDataField.createdAt,
  ICTDataField.updatedAt,

];

List<ICTDataField> ictFieldsFromOldRecords = [
  ICTDataField.firstName,
  ICTDataField.lastName,
  ICTDataField.dob,
  ICTDataField.gender,
  ICTDataField.phone,
  ICTDataField.email,
  ICTDataField.bvn,
  ICTDataField.address,
  ICTDataField.isCivilServant,
  ICTDataField.businessName,
  ICTDataField.businessAddress,
  ICTDataField.businessLGA,
  ICTDataField.businessRegCat,
  ICTDataField.businessRegIssuer,
  ICTDataField.businessRegNum,
  ICTDataField.yearsInOperation,
  ICTDataField.numStaff,
  ICTDataField.ictProcCat,
  ICTDataField.complPurchase1,
  ICTDataField.complPurchase2,
  ICTDataField.complPurchase3,
  ICTDataField.costOfItems,
  ICTDataField.accountName,
  ICTDataField.accountNumber,
  ICTDataField.bank,
  ICTDataField.ictToBeProcured,
  ICTDataField.costOfIntendedIct,
  ICTDataField.taxRegNum,
  ICTDataField.taxIssuer,
];

List<List<ICTDataField>> ictDatabaseFieldsPages = [
  [
    ICTDataField.id,
    ICTDataField.firstName,
    ICTDataField.lastName,
    ICTDataField.dob,
    ICTDataField.gender,
    ICTDataField.phone,
    ICTDataField.bvn,
    ICTDataField.nin,
    ICTDataField.email,
    ICTDataField.homeAddress,
    ICTDataField.businessName,
    ICTDataField.businessAddress,
    ICTDataField.businessLGA,
    ICTDataField.businessLGACode,
    ICTDataField.businessWard,
    ICTDataField.catType,
    ICTDataField.idDocType,
    ICTDataField.businessRegIssuer,
    ICTDataField.businessRegNum,
    ICTDataField.latitude,
    ICTDataField.longitude,
    ICTDataField.yearsInOperation,
    ICTDataField.numStaff,
    ICTDataField.comment,
    ICTDataField.bank,
    ICTDataField.accountNumber,
    ICTDataField.accountName,
    ICTDataField.taxId,
    ICTDataField.issuer,
    ICTDataField.createdAt,
    ICTDataField.updatedAt,
  ],
  [
    ICTDataField.idDocPhotoUrl,
  ],
  [
    ICTDataField.ownerPassportPhotoUrl,
  ],
  [
    ICTDataField.certPhotoUrl,
    ICTDataField.cacProofDocPhotoUrl,
  ],
  [
    ICTDataField.ownerAtBusinessPhotoUrl,
  ],
  [
    ICTDataField.groupPhotoUrl,
  ],
  [
    ICTDataField.renumerationPhotoUrl,
  ],
  [
    ICTDataField.taxRegPhotoUrl,
  ]
];