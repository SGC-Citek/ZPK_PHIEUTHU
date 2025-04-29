//*----------------------------------------------------------------------*
//* Citek JSC.
//* (C) Copyright Citek JSC.
//* All Rights Reserved
//*----------------------------------------------------------------------*
//* Application: Phiếu thu PTP
//* Creation Date:
//* Created by: Minh Thuy
//*----------------------------------------------------------------------*
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Phiếu thu'
@Search.searchable: true
//@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
//@ObjectModel.usageType:{
//    serviceQuality: #X,
//    sizeCategory: #S,
//    dataClass: #MIXED
//}
define root view entity ZFI_I_PHTHU
  with parameters
    OwnDocumentOnly : zde_boolean
  as select distinct from I_JournalEntry            as bkpf
    inner join            I_OperationalAcctgDocItem as bseg             on  bkpf.CompanyCode        =    bseg.CompanyCode
                                                                        and bkpf.FiscalYear         =    bseg.FiscalYear
                                                                        and bkpf.AccountingDocument =    bseg.AccountingDocument
                                                                        and bseg.GLAccount          like '111%'
                                                                        and bseg.PostingKey         =    '40'
                                                                        and bkpf.IsReversal         <>   'X'
  //    left outer join            ZFI_I_PHTHU_CUS_VEN   as _AccountType          on  bkpf.CompanyCode        = _AccountType.CompanyCode
  //                                                                         and bkpf.FiscalYear         = _AccountType.FiscalYear
  //                                                                         and bkpf.AccountingDocument = _AccountType.AccountingDocument

    left outer join       I_CompanyCode             as companyCode      on bkpf.CompanyCode = companyCode.CompanyCode

    left outer join       I_Address_2               as company_address  on companyCode.AddressID = company_address.AddressID
    left outer join       ZFI_I_PCHI_CUS            as D                on  bkpf.CompanyCode        = D.CompanyCode
                                                                        and bkpf.FiscalYear         = D.FiscalYear
                                                                        and bkpf.AccountingDocument = D.AccountingDocument
  //    left outer join       I_AddrOrgNamePostalAddress as customer_address on D.AddressID = customer_address.AddressID
    left outer join       ZFI_I_PCHI_SUP            as K                on  bkpf.CompanyCode        = K.CompanyCode
                                                                        and bkpf.FiscalYear         = K.FiscalYear
                                                                        and bkpf.AccountingDocument = K.AccountingDocument
    left outer join       ZI_CHUKY                  as ChuKiTONGGIAMDOC on ChuKiTONGGIAMDOC.Id = 'TONGGIAMDOC'
    left outer join       ZI_CHUKY                  as ktt              on ktt.Id = 'KETOANTRUONG'
    left outer join       ZI_CHUKY                  as thuQuy           on thuQuy.Id = 'THUQUY'
    left outer join       ZFI_I_PCHI_COUNTCUS       as _z_countcus      on  bkpf.CompanyCode        = _z_countcus.CompanyCode
                                                                        and bkpf.FiscalYear         = _z_countcus.FiscalYear
                                                                        and bkpf.AccountingDocument = _z_countcus.AccountingDocument
    left outer join       ZFI_I_PCHI_COUNTSUP       as _z_countsup      on  bkpf.CompanyCode        = _z_countsup.CompanyCode
                                                                        and bkpf.FiscalYear         = _z_countsup.FiscalYear
                                                                        and bkpf.AccountingDocument = _z_countsup.AccountingDocument
    left outer join       I_OneTimeAccountSupplier  as bsec             on  bkpf.CompanyCode        = bsec.CompanyCode
                                                                        and bkpf.FiscalYear         = bsec.FiscalYear
                                                                        and bkpf.AccountingDocument = bsec.AccountingDocument
    left outer join       I_OneTimeAccountCustomer  as bsecCus           on  bkpf.CompanyCode       = bsecCus.CompanyCode
                                                                        and bkpf.FiscalYear         = bsecCus.FiscalYear
                                                                        and bkpf.AccountingDocument = bsecCus.AccountingDocument
  composition [0..*] of ZFI_I_PHTHU_ITEM       as _Item
//  association [1..1] to ZFI_I_PHTHU_TAIKHOANNO as _TaiKhoanNo on  $projection.CompanyCode        = _TaiKhoanNo.CompanyCode
//                                                              and $projection.AccountingDocument = _TaiKhoanNo.AccountingDocument
//                                                              and $projection.FiscalYear         = _TaiKhoanNo.FiscalYear
//
//  association [1..1] to ZFI_I_PHTHU_TAIKHOANCO as _TaiKhoanCo on  $projection.CompanyCode        = _TaiKhoanCo.CompanyCode
//                                                              and $projection.AccountingDocument = _TaiKhoanCo.AccountingDocument
//                                                              and $projection.FiscalYear         = _TaiKhoanCo.FiscalYear



{
      @Consumption.filter: { mandatory: true , selectionType: #SINGLE,
        multipleSelections: false , defaultValue: '1000' }
      @Search.defaultSearchElement: true
  key bkpf.CompanyCode,
      @Consumption.filter: { mandatory: true , selectionType: #SINGLE,
      multipleSelections: false }
      @Search.defaultSearchElement: true
  key bkpf.FiscalYear,
      //@Consumption.valueHelpDefinition: [{entity: {name: 'I_JournalEntry', element: 'AccountingDocument' }}]
      @Search.defaultSearchElement: true
  key bkpf.AccountingDocument,
      @Search.defaultSearchElement: true
      cast( bkpf.DocumentReferenceID as zde_reference)                                                                                                                                        as Reference, //Reference 2 (Kèm theo)
      bkpf.AccountingDocCreatedByUser,
      bseg.DocumentDate,
      @Search.defaultSearchElement: true
      bkpf.AccountingDocumentCreationDate,
      @Aggregation.default: #SUM
      bseg.AmountInCompanyCodeCurrency,
      bseg.CompanyCodeCurrency,

      //      _AccountType.Supplier, //Supplier 9
      //      _AccountType.Customer, //Customer 10

      //      case
      //        when _AccountType.Supplier = ''
      //            then _AccountType._Customer.CustomerName
      //            else _AccountType._Supplier.SupplierName
      //      end
      case when _z_countcus.CountCus = 1 then D.CustomerName
          when _z_countsup.CountSup = 1 then K.SupplierName
          else  ''                                                                    end                                                                                                     as AccountName,
      
      @Consumption.filter.hidden: true
      @UI: {  lineItem:       [ { position: 180, label: 'Customer' } ] }
      case when _z_countcus.CountCus = 1 then D.Customer
          else  ''                                                                    
          end  as Customer,
          
      @Consumption.filter.hidden: true
      @UI: {  lineItem:       [ { position: 190, label: 'Supplier' } ] }
      case when _z_countsup.CountSup = 1 then K.Supplier
          else  ''                                                                    
          end  as Supplier,
                    
      bseg.DocumentItemText,
      bkpf.AccountingDocumentType,
      @Consumption.filter.hidden: true
      @UI.hidden: true
      company_address.AddresseeFullName                                                                                                                                                       as TenCongTy,
      @Consumption.filter.hidden: true
      //      concat_with_space( company_address.StreetName,
      //      concat_with_space(company_address.StreetPrefixName1,
      //      concat_with_space(company_address.StreetPrefixName2,company_address.StreetSuffixName1,1),1),1) as DiaChiCty,
      @UI.hidden: true
      concat_with_space( company_address.StreetName,company_address.StreetPrefixName1,1)                                                                                                    as DiaChiCTy,
      @Search.defaultSearchElement: true
      bseg.PostingDate,
      //Người nhận tiền //sửa ở đây
      //      @Consumption.filter.hidden: true
      //      case
      //            when _AccountType._Customer.BusinessPartnerName1 <> ''
      //                then _AccountType._Customer.BusinessPartnerName1
      //            when concat_with_space(_AccountType._Customer.BusinessPartnerName2,concat_with_space(_AccountType._Customer.BusinessPartnerName3,_AccountType._Customer.BusinessPartnerName4,1),1) <> ''
      //                then concat_with_space(_AccountType._Customer.BusinessPartnerName2,concat_with_space(_AccountType._Customer.BusinessPartnerName3,_AccountType._Customer.BusinessPartnerName4,1),1)
      //            when _AccountType._Supplier.BusinessPartnerName1 <> ''
      //                then _AccountType._Supplier.BusinessPartnerName1
      //            when concat_with_space(_AccountType._Supplier.BusinessPartnerName2,concat_with_space(_AccountType._Supplier.BusinessPartnerName3,_AccountType._Supplier.BusinessPartnerName4,1),1) <> ''
      //                then concat_with_space(_AccountType._Supplier.BusinessPartnerName2,concat_with_space(_AccountType._Supplier.BusinessPartnerName3,_AccountType._Supplier.BusinessPartnerName4,1),1)
      //
      //      end
      @UI.hidden: true
      ''                                                                                                                                                                                      as NguoiNhanTien,
      //Địa chỉ 5
      //      @Consumption.filter.hidden: true
      //    case
      //        when
      //            concat_with_space(_AccountType._Customer._AddressRepresentation.StreetName,concat_with_space(_AccountType._Customer._AddressRepresentation.StreetPrefixName1,
      //             concat_with_space(_AccountType._Customer._AddressRepresentation.StreetPrefixName2,
      //             concat_with_space(_AccountType._Customer._AddressRepresentation.StreetSuffixName1,
      //             concat_with_space(_AccountType._Customer._AddressRepresentation.DistrictName,_AccountType._Customer._AddressRepresentation.CityName,1),1),1),1),1) <> ''
      //            then concat_with_space(_AccountType._Customer._AddressRepresentation.StreetName,concat_with_space(_AccountType._Customer._AddressRepresentation.StreetPrefixName1,
      //             concat_with_space(_AccountType._Customer._AddressRepresentation.StreetPrefixName2,
      //             concat_with_space(_AccountType._Customer._AddressRepresentation.StreetSuffixName1,
      //             concat_with_space(_AccountType._Customer._AddressRepresentation.DistrictName,_AccountType._Customer._AddressRepresentation.CityName,1),1),1),1),1)
      //            else concat_with_space(_AccountType._Supplier._AddressRepresentation.StreetName,concat_with_space(_AccountType._Supplier._AddressRepresentation.StreetPrefixName1,
      //             concat_with_space(_AccountType._Supplier._AddressRepresentation.StreetPrefixName2,
      //             concat_with_space(_AccountType._Supplier._AddressRepresentation.StreetSuffixName1,
      //             concat_with_space(_AccountType._Supplier._AddressRepresentation.DistrictName,_AccountType._Supplier._AddressRepresentation.CityName,1),1),1),1),1)
      //    end
      @UI.hidden: true
      ''                                                                                                                                                                                      as DiaChiNguoiNhanTien,

      //Lý do thu
      @Consumption.filter.hidden: true
      case
           when  bseg.DocumentItemText <> ''
                then bseg.DocumentItemText
                else
                bkpf.AccountingDocumentHeaderText
      end                                                                                                                                                                                     as LyDoThu,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      @Consumption.filter.hidden: true
      bseg.AmountInTransactionCurrency                                                                                                                                                        as SoTien,
      
      @UI.selectionField: [{ position: 70 }]
      @Consumption.valueHelpDefinition: [{entity: {name: 'I_CurrencyStdVH', element: 'Currency' }}]
      bseg.TransactionCurrency,
      
      @Consumption.valueHelpDefinition: [{entity: {name: 'I_AccountingDocumentCategory', element: 'AccountingDocumentCategory' }}]
      @Search.defaultSearchElement: true
      @UI.hidden: true
      cast( bseg.AccountingDocumentCategory as zde_entrycategory)                                                                                                                             as Type,
      @Consumption.filter: { mandatory: false , selectionType: #SINGLE,
      multipleSelections: false , defaultValue: ' ' }
      @Search.defaultSearchElement: true
      bkpf.IsReversed,
      case when bseg.AddressAndBankIsSetManually = '' and D.IsOneTimeAccount = '' and D.FinancialAccountType = 'D'
                      then
                         case when D.BusinessPartnerName2 <> '' or D.BusinessPartnerName3 <> '' or D.BusinessPartnerName4 <> ''
                              then concat_with_space(concat_with_space(D.BusinessPartnerName2,D.BusinessPartnerName3,1),D.BusinessPartnerName4,1)
                        else D.BusinessPartnerName1
                     end
           when bseg.AddressAndBankIsSetManually = '' and K.IsOneTimeAccount = '' and K.FinancialAccountType = 'K'
                     then
                         case when K.BusinessPartnerName2 <> '' or K.BusinessPartnerName3 <> '' or K.BusinessPartnerName4 <> ''
                              then concat_with_space(concat_with_space(K.BusinessPartnerName2,K.BusinessPartnerName3,1),K.BusinessPartnerName4,1)
                        else K.BusinessPartnerName1
                     end
          else case when _z_countsup.CountSup = 1 
                    then concat_with_space(concat_with_space(concat_with_space( bsec.BusinessPartnerName1, bsec.BusinessPartnerName2, 1 ),bsec.BusinessPartnerName3,1),bsec.BusinessPartnerName4,1) 
                    else concat_with_space(concat_with_space(concat_with_space( bsecCus.BusinessPartnerName1, bsecCus.BusinessPartnerName2, 1 ),bsecCus.BusinessPartnerName3,1),bsecCus.BusinessPartnerName4,1)
                end
          end as HoVaTen,
          
          @UI.hidden: true
          _z_countcus.CountCus,
          @UI.hidden: true
          _z_countsup.CountSup,
          
      case   when bseg.AddressAndBankIsSetManually = '' and D.IsOneTimeAccount = '' and D.FinancialAccountType = 'D'
                   then
                        case when D.DistrictName <> ''
                             then concat_with_space(concat(concat_with_space(concat(D.StreetName, ','), D.DistrictName, 1), ','), D.CityName, 1)
                             else concat_with_space(concat(D.StreetName, ','), D.CityName, 1)
                        end
             when bseg.AddressAndBankIsSetManually = '' and K.IsOneTimeAccount = '' and K.FinancialAccountType = 'K'
                     then  case when K.DistrictName <> ''
                             then concat_with_space(concat(concat_with_space(concat(K.StreetName, ','), K.DistrictName, 1), ','), K.CityName, 1)
                             else concat_with_space(concat(K.StreetName, ','), K.CityName, 1)
                     end
             else case when _z_countsup.CountSup = 1 
                    then concat_with_space(concat(bsec.StreetAddressName,','), bsec.CityName, 1)  
                    else concat_with_space(concat(bsecCus.StreetAddressName,','), bsecCus.CityName, 1) 
                  end                                                  
             end as DiaChi,
      //Chữ Ký
      //      @Consumption.filter.hidden: true
      //      ChuKiTONGGIAMDOC.Hoten                                                               as IdGiamDoc,
      //      @Consumption.filter.hidden: true
      //      ktt.Hoten                                                                            as IdKeToan,
      //      @Consumption.filter.hidden: true
      //      thuQuy.Hoten                                                                         as IdThuQuy,
      _Item
}
where
  bkpf.AccountingDocumentType = 'C1' and
  (
    (
          $parameters.OwnDocumentOnly     is initial
      and bkpf.IsReversed                 = ''
    )
    or(
          $parameters.OwnDocumentOnly     is not initial
      and bkpf.AccountingDocCreatedByUser = $session.user
      and bkpf.IsReversed                 = ''
    )
  )
