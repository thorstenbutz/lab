###################
## Parameter(Sets)
###################

## Remoting
Get-Command | Where-Object -FilterScript {
    $_.parameters.keys -contains 'ComputerName'
}

## Remoting
Get-Command | Where-Object -FilterScript {
    $_.parameters.keys -contains 'Targetname'
}

## Get all parameters from a specific Cmdlet
Get-Command -Name Get-LocalUser | ForEach-Object -Process {
    $_.Parameters.Keys   
}

## Parametersets
(Get-Command -Name Get-LocalUser).ParameterSets | Format-List

$overview = foreach ($ParameterSet in (Get-Command -Name Get-LocalUser).ParameterSets) {      
    foreach ($Parameter in $ParameterSet.Parameters) { 
        [PSCustomObject]    @{ 
            'ParameterSet'                      = $ParameterSet.Name 
            'ParameterName'                     = $Parameter.Name
            'ParameterAlias'                    = $Parameter.Aliases
            'ParameterType'                     = $Parameter.ParameterType
            'isMandatory'                       = $Parameter.isMandatory
            'isDynamic'                         = $Parameter.IsDynamic
            'PipeByValue'        = $Parameter.ValueFromPipeline
            'PipeByPropteryName' = $Parameter.ValueFromPipelineByPropertyName
        }
    }
}
$overview | Select-Object -Property ParameterSet,Parametername,ParameterAlias
$overview | Format-Table -AutoSize