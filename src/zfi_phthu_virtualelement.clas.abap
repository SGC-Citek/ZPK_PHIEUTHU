class zfi_phthu_virtualelement definition
  public
  final
  create public .

  public section.
    interfaces if_sadl_exit_calc_element_read.
  protected section.
  private section.
ENDCLASS.



CLASS ZFI_PHTHU_VIRTUALELEMENT IMPLEMENTATION.


  method if_sadl_exit_calc_element_read~calculate.
    data: lt_data type standard table of zfi_i_phthu with default key.
    loop at lt_data assigning field-symbol(<PhieuThu>).
 "

    endloop.
  endmethod.


  method if_sadl_exit_calc_element_read~get_calculation_info.
  endmethod.
ENDCLASS.
