//*----------------------------------------------------------------------*
//* Citek JSC.
//* (C) Copyright Citek JSC.
//* All Rights Reserved
//*----------------------------------------------------------------------*
//* Application: Phiếu thu PTP
//* Creation Date: 
//* Created by: Minh Thuy
//*----------------------------------------------------------------------*
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Phiếu thu item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_PHTHU_ITEM as select  from I_OperationalAcctgDocItem as bseg

//inner join            ZFI_I_PHTHU_CUS_VEN   as _AccountType          on  bseg.CompanyCode        = _AccountType.CompanyCode
//                                                                         and bseg.FiscalYear         = _AccountType.FiscalYear
//                                                                         and bseg.AccountingDocument = _AccountType.AccountingDocument

  association [1..1] to ZFI_I_PHTHU_TAIKHOANNO   as _TaiKhoanNo      on  $projection.CompanyCode        = _TaiKhoanNo.CompanyCode
                                                                     and $projection.AccountingDocument = _TaiKhoanNo.AccountingDocument
                                                                     and $projection.FiscalYear         = _TaiKhoanNo.FiscalYear
                                                                     and $projection.GLAccount          = _TaiKhoanNo.GLAccount

  association [1..1] to ZFI_I_PHTHU_TAIKHOANCO   as _TaiKhoanCo      on  $projection.CompanyCode        = _TaiKhoanCo.CompanyCode
                                                                     and $projection.AccountingDocument = _TaiKhoanCo.AccountingDocument
                                                                     and $projection.FiscalYear         = _TaiKhoanCo.FiscalYear
                                                                     and $projection.GLAccount          = _TaiKhoanCo.GLAccount

association to parent ZFI_I_PHTHU as _Header on  $projection.AccountingDocument = _Header.AccountingDocument
                                                     and $projection.CompanyCode        = _Header.CompanyCode
                                                     and $projection.FiscalYear= _Header.FiscalYear
{
    key bseg.CompanyCode,//Tên công ty
    key bseg.AccountingDocument,
    key bseg.FiscalYear,
//    key bseg.AccountingDocumentItem,
    key bseg.GLAccount,
    bseg.TransactionCurrency,
    case 
        when bseg.DebitCreditCode = 'S'
            then bseg.GLAccount
     end as TaiKhoanNo,
     case 
        when bseg.DebitCreditCode = 'H'
            then bseg.GLAccount
     end as TaiKhoanCo,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    case 
        when bseg.DebitCreditCode = 'S'
            then sum(bseg.AmountInTransactionCurrency)
     end as SoTienNo,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
     case 
        when bseg.DebitCreditCode = 'H'
            then sum(bseg.AmountInTransactionCurrency)
     end as SoTienCo,
//    bseg.DebitCreditCode,
//     //Tài khoản nợ
//      _TaiKhoanNo.GLAccount                                                                     as TaiKhoanNo,
//      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//      _TaiKhoanNo.SumAmountInTransactionCurrency                                                     as SoTienNo,
//      _TaiKhoanNo.TransactionCurrencyNo,
//      //Tài khoản có
//      _TaiKhoanCo.GLAccount             
//                                                                   as TaiKhoanCo,
//       @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//      case
//        when _TaiKhoanCo.SumAmountInTransactionCurrency < 0
//            then _TaiKhoanCo.SumAmountInTransactionCurrency * (-1)
//            else _TaiKhoanCo.SumAmountInTransactionCurrency
//            end                                                    as SoTienCo,
//      _TaiKhoanCo.TransactionCurrencyCo,
    _Header
} group by CompanyCode, FiscalYear, AccountingDocument,GLAccount, TransactionCurrency,bseg.DebitCreditCode,bseg.GLAccount
