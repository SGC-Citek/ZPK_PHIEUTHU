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
@EndUserText.label: 'Tài khoản nợ'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZFI_I_PHTHU_TAIKHOANNO as select distinct from I_OperationalAcctgDocItem as bseg
{
   key bseg.CompanyCode,
   key bseg.FiscalYear,
   key bseg.AccountingDocument,
   key bseg.GLAccount,
   @Semantics.amount.currencyCode: 'TransactionCurrencyNo'
   sum(bseg.AmountInTransactionCurrency 
        ) as SumAmountInTransactionCurrency,
   bseg.TransactionCurrency as TransactionCurrencyNo
   //_Header     
}where  (bseg.DebitCreditCode = 'S' ) group by CompanyCode, FiscalYear, AccountingDocument,GLAccount, TransactionCurrency
