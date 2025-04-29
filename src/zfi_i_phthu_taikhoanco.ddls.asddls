@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Tài khoản có'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_PHTHU_TAIKHOANCO as select distinct from I_OperationalAcctgDocItem as bseg
{
   key bseg.CompanyCode,
   key bseg.FiscalYear,
   key bseg.AccountingDocument,
   key bseg.GLAccount,
   @Semantics.amount.currencyCode: 'TransactionCurrencyCo'
   sum(bseg.AmountInTransactionCurrency
        ) as SumAmountInTransactionCurrency,
   bseg.TransactionCurrency as TransactionCurrencyCo
}where  (bseg.DebitCreditCode = 'H') group by CompanyCode, FiscalYear, AccountingDocument,GLAccount, TransactionCurrency
