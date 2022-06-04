Param(
    [Parameter(Mandatory=$true)]$data,     # ログファイル名を文字列で指定する。
    [Parameter(Mandatory=$true)]$outFolder # プロンプト部分を文字列で指定する。
)

New-Item -ItemType Directory -Force $outFolder

$data.Keys | foreach {

    $name = $_ -replace " ", "_"
    $invalidChars = [IO.Path]::GetInvalidFileNameChars() -join ''
    $re = "[{0}]" -f [RegEx]::Escape($invalidChars)
    $name = $name -replace $re, '_'
    $outpath = Join-Path $outFolder $name

    $data[$_] > $outpath
}