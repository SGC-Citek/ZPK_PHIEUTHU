@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Test data address'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_PHTHU_TESTDATA_ADDRESS as select from I_OneTimeAccountCustomer
{
key CompanyCode,
key AccountingDocument,
key FiscalYear,
key AccountingDocumentItem,
BusinessPartnerName1,
BusinessPartnerName2,
BusinessPartnerName3,
BusinessPartnerName4,
Country,
CityName,
POBox,
POBoxPostalCode,
PostalCode,
Region,
TaxID1,
TaxID2,
TaxID3,
TaxID4,
TaxID5,
StreetAddressName,
TaxNumberType,
AddressID,
AccountingClerkInternetAddress,
IsNaturalPerson,
AuthorizationGroup,
PayerIsAlternativePayer,
Customer,
/* Associations */
_Address,
_CompanyCode,
_CustomerCompany,
_FiscalYear,
_JournalEntry,
_OperationalAcctgDocItem
}
