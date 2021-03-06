
#コマンドライン引数
#--------------------------------------------------
Param(
    [Parameter(Mandatory=$true)]$logfile, # ログファイル名を文字列で指定する。
    [Parameter(Mandatory=$true)]$prompt   # プロンプト部分を文字列で指定する。
)

function splitCmdInput() {

    # 指定したログファイルを開き、文字列データとして保持する。
    $f = (Get-Content $logfile) -as [String[]]

    # 1ブロック分の結果文字列
    $oneBlockStr = ""

    #結果を保存する
    $results = [ordered]@{}

    #1ブロック分の文字列配列
    $oneBlockStr = @()

    # 初回判定
    $isFirst = $true

    # 1行ごとにループする。
    foreach($line in $f) {

        # 行頭がプロンプト文字列かどうかを判定する。
        if($line -match "^$prompt`(.*)") {

            # プロンプト文字列の場合

            # 初プロンプト判定
            if($true -eq $isFirst) {

                # 初回の場合

                $key = "Begin"
                $data = $oneBlockStr -join "`r`n"
                $results[$key] = $data

                $oneBlockStr = @()
                $isFirst = $false
                continue
            }

            # 初回でない場合

            $key = $matches[1]
            $data = $oneBlockStr -join "`r`n"
            $results[$key] = $data
            $oneBlockStr = @()
            continue
        }

        # 行頭がプロンプト文字列でない場合
        $oneBlockStr += $line

    }

    if("" -ne $oneBlockStr[0])
    {
        $key = $matches[1]
        $data = $oneBlockStr -join "`r`n"
        $results[$key] = $data
        $oneBlockStr = @()
    }

    return $results
}

return splitCmdInput($logfile, $prompt)