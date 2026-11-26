// Power Query (M) for the Orders table. File path shortened; point it at your own copy of the CSV.
let
  Source = Csv.Document(File.Contents("Orders.csv"), [Delimiter = ",", Columns = 6, Encoding = 65001, QuoteStyle = QuoteStyle.None]),
  #"Promoted headers" = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
  #"Split column by delimiter" = Table.SplitColumn(#"Promoted headers", "order_date", Splitter.SplitTextByEachDelimiter({"T"}, QuoteStyle.Csv), {"order_date.1", "order_date.2"}),
  #"Changed column type" = Table.TransformColumnTypes(#"Split column by delimiter", {{"order_id", type text}, {"order_date.1", type text}, {"order_date.2", type time}, {"user_crm_id", Int64.Type}, {"device_category", type text}, {"delivery_region", type text}, {"delivery_fee", type text}}),
  #"Removed columns" = Table.RemoveColumns(#"Changed column type", {"order_date.2"}),
  #"Renamed columns" = Table.RenameColumns(#"Removed columns", {{"order_date.1", "order_date"}}),
  #"Changed column type with locale" = Table.TransformColumnTypes(#"Renamed columns", {{"order_date", type date}}, "en-GB"),
  #"Trimmed text" = Table.TransformColumns(#"Changed column type with locale", {{"device_category", each Text.Trim(_), type nullable text}, {"delivery_region", each Text.Trim(_), type nullable text}}),
  #"Cleaned text" = Table.TransformColumns(#"Trimmed text", {{"device_category", each Text.Clean(_), type nullable text}, {"delivery_region", each Text.Clean(_), type nullable text}}),
  #"Capitalized each word" = Table.TransformColumns(#"Cleaned text", {{"device_category", each Text.Proper(_), type nullable text}, {"delivery_region", each Text.Proper(_), type nullable text}}),
  #"Changed column type with locale 1" = Table.TransformColumnTypes(#"Capitalized each word", {{"delivery_fee", type number}}, "en-GB"),
  #"Changed column type with locale 2" = Table.TransformColumnTypes(#"Changed column type with locale 1", {{"delivery_fee", Currency.Type}}, "en-GB"),
  #"Filtered rows" = Table.SelectRows(#"Changed column type with locale 2", each [order_date] >= #date(2020, 1, 1) and [order_date] <= #date(2021, 12, 31)),
  #"Trimmed text 1" = Table.TransformColumns(#"Filtered rows", {{"order_id", each Text.Trim(_), type nullable text}}),
  #"Cleaned text 1" = Table.TransformColumns(#"Trimmed text 1", {{"order_id", each Text.Clean(_), type nullable text}})
in
  #"Cleaned text 1"
