# Excel formulas

Copied from the workbook. Table and sheet names are the ones Power Query loaded.

## Items_sold table

Order date for each item, looked up from the Orders table:

```excel
=XLOOKUP(Items_sold[[#This Row],[order_id]], Orders!A:A, Orders!B:B, "Date Not Found")
```

Quarter label (`G` is the order date column):

```excel
=YEAR(G2)&" Q"&ROUNDUP(MONTH(G2)/3,0)
```

Line revenue:

```excel
=Items_sold[[#This Row],[quantity]]*Items_sold[[#This Row],[unit_price]]
```

## Orders table

Quarter label (`B` is the order date column):

```excel
=YEAR(B2)&" Q"&ROUNDUP(MONTH(B2)/3,0)
```

## KPI Summary sheet

Units sold and revenue per quarter come from a PivotTable on Items_sold (rows: quarter; values: sum of quantity, sum of line revenue).

Orders per quarter (`A3` holds the quarter label, Orders column `G` holds the quarter):

```excel
=COUNTIF(Orders!$G:$G, A3)
```

Metrics (`B` units, `C` revenue, `D` orders):

```excel
AOV  =C3/D3
UPT  =B3/D3
AUP  =C3/B3
```
