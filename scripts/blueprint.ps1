 <#
.Synopsis
   New demo demonstrates the smart transfer of multiple item (arrays) to a cmdlet.
.DESCRIPTION
   Quantities can be passed using the pipeline or directly as an argument for a parameter. 
   The challenge here is that if you pass multiple elements through the pipeline, 
   PowerShell processes these items as individual elements (“scalar”) in repeated calls 
   to the process block.
   It makes sense to combine the values passed via the pipeline in an array and then 
   process them in the same way as the values passed directly to the parameters.
.EXAMPLE
    New-Demo -number 10,22,33    
.EXAMPLE
    50,66,77 | New-Demo
#>
function New-Demo {
    [CmdletBinding()]        
    param (        
        [Parameter(Mandatory,ValueFromPipeline)]
        [int[]] $Number ## INPUT from user
    )
    begin {
        '(c) Contoso LTD, 2025'
    }
    process {
        ## Collect pipeline input (if any)
        $Numbers += $Number
    }
    end {
        ## Main action
        foreach ($item in $Numbers) { 
            $item + 1
        }
    }
}
 New-Demo -number 10,22,33
 50,66,77 | New-Demo