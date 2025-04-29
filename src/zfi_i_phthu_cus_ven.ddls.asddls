@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer vender'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_PHTHU_CUS_VEN 
as select distinct from I_OperationalAcctgDocItem as bseg
 association [1..1] to I_Customer as _Customer on $projection.Customer = _Customer.Customer
 association [1..1] to I_Supplier as _Supplier on $projection.Supplier = _Supplier.Supplier
 association [1..1] to I_OneTimeAccountCustomer as _OneTime on $projection.CompanyCode = _OneTime.CompanyCode
 and $projection.AccountingDocument = _OneTime.AccountingDocument
 and $projection.AccountingDocumentItem = _OneTime.AccountingDocumentItem
 and $projection.FiscalYear = _OneTime.FiscalYear
{
  key bseg.CompanyCode, 
  key bseg.FiscalYear, 
  key bseg.AccountingDocument,
  key bseg.AccountingDocumentItem,
  bseg.Customer,
  bseg.Supplier,
  bseg.FinancialAccountType,
  
  _Customer._AddressRepresentation.StreetName as customerStreetName,
  _Supplier._AddressRepresentation.StreetName as supplierStreetName,
   _Customer,
   _Supplier,
   _OneTime
}where ( bseg.FinancialAccountType = 'K' or bseg.FinancialAccountType = 'D' ) 
