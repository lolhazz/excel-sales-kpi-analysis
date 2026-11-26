// Power Query (M) for the Items_sold table. File path shortened; point it at your own copy of the CSV.
let
  Source = Csv.Document(File.Contents("Items_sold.csv"), [Delimiter = ",", Columns = 6, Encoding = 65001, QuoteStyle = QuoteStyle.None]),
  #"Promoted headers" = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{"order_id", type text}, {"item_id", type text}, {"product_name", type text}, {"category", type text}, {"quantity", Int64.Type}, {"unit_price", type text}}),
  #"Trimmed text" = Table.TransformColumns(#"Changed column type", {{"product_name", each Text.Trim(_), type nullable text}, {"category", each Text.Trim(_), type nullable text}}),
  #"Cleaned text" = Table.TransformColumns(#"Trimmed text", {{"product_name", each Text.Clean(_), type nullable text}, {"category", each Text.Clean(_), type nullable text}}),
  #"Capitalized each word" = Table.TransformColumns(#"Cleaned text", {{"product_name", each Text.Proper(_), type nullable text}, {"category", each Text.Proper(_), type nullable text}}),
  #"Split column by delimiter" = Table.SplitColumn(#"Capitalized each word", "unit_price", Splitter.SplitTextByEachDelimiter({"GBP"}, QuoteStyle.Csv), {"unit_price.1", "unit_price.2"}),
  #"Changed column type with locale" = Table.TransformColumnTypes(#"Split column by delimiter", {{"unit_price.1", Currency.Type}}, "en-GB"),
  #"Removed columns" = Table.RemoveColumns(#"Changed column type with locale", {"unit_price.2"}),
  #"Renamed columns" = Table.RenameColumns(#"Removed columns", {{"unit_price.1", "unit_price"}}),
  #"Trimmed text 1" = Table.TransformColumns(#"Renamed columns", {{"order_id", each Text.Trim(_), type nullable text}}),
  #"Trimmed text 2" = Table.TransformColumns(#"Trimmed text 1", {{"order_id", each Text.Trim(_), type nullable text}, {"item_id", each Text.Trim(_), type nullable text}}),
  #"Cleaned text 1" = Table.TransformColumns(#"Trimmed text 2", {{"order_id", each Text.Clean(_), type nullable text}, {"item_id", each Text.Clean(_), type nullable text}})
in
  #"Cleaned text 1"
