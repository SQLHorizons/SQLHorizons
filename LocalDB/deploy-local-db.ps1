$name = "db-oc03"
$state = ""

Set-Location "C:\Program Files\Microsoft SQL Server\130\Tools\Binn"

$status = .\SqlLocalDB i $name

foreach ($line in $status) {
    if ($line -like "State:*") {
        switch (($line.Split(":")[-1]).TrimStart()) {
            "Stopped" {
                .\SqlLocalDB s $name | Out-Null;
                $status = .\SqlLocalDB i $name
                foreach ($line in $status) {
                    if ($line -like "Instance pipe name:*") {
                        $pipe = $line.Split(":")[-1]
                    }
                }; break
            }
            "Running" {
                foreach ($line in $status) {
                    if ($line -like "Instance pipe name:*") {
                        $pipe = $line.Split(":")[-1]
                    }
                }; break}
        }

    }
    else {
        .\SqlLocalDB c $name | Out-Null;
        .\SqlLocalDB s $name | Out-Null;
        $status = .\SqlLocalDB i $name
        foreach ($line in $status) {
            if ($line -like "Instance pipe name:*") {
                $pipe = $line.Split(":")[-1]
            }
        }; break
    }
}

$pipe
.\SqlLocalDB i
