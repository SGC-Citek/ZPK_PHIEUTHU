@AbapCatalog.sqlViewName: 'ZFLIGHT_VW'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Tài khoản nợ'
define view ZFI_I_PHTHU_TAIKHOANNO2 as select from I_OperationalAcctgDocItem as bseg
//association to parent ZFI_I_PHTHU as _Header on  $projection.AccountingDocument = _Header.AccountingDocument
//                                                     and $projection.CompanyCode        = _Header.CompanyCode
//                                                     and $projection.FiscalYear= _Header.FiscalYear
{
//   key bseg.CompanyCode,
//   key bseg.FiscalYear,
//   key bseg.AccountingDocument,
//   SELECT bseg.GLAccount SUM( bseg.AmountInTransactionCurrency ) AS SUMAmountInTransactionCurrency
//    FROM bseg
//        GROUP BY bseg.GLAccount.
   key bseg.GLAccount,
   @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
   sum(bseg.AmountInTransactionCurrency) as SumAmountInTransactionCurrency,
   bseg.CompanyCodeCurrency
   //_Header     
}group by GLAccount ,CompanyCodeCurrency
