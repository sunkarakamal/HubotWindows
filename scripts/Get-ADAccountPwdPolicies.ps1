


 function Get-ADAccountPwdPolicies
{
   
    [CmdletBinding()]
    Param
    (
        # Name of the domain
        [Parameter(Mandatory=$true)]
        $name
    )
     
    # Create a hashtable for the results
    $result = @{}
    
    # Use try/catch block            
    try
    {
    $name = $name -replace ">"
     $name = $name -replace "<"
        $RootDSE = Get-ADRootDSE -Server $name
        # Use ErrorAction Stop to make sure we can catch any errors
        $PasswordPolicy = Get-ADObject $RootDSE.defaultNamingContext -Property minPwdAge,maxPwdAge,minPwdLength,pwdHistoryLength,pwdProperties -Server $name
        
        # Create a string for sending back to slack. * and ` are used to make the output look nice in Slack. Details: http://bit.ly/MHSlackFormat
         $result.output = "Domain  is $($name) : Password policy, Minimum pwd age is ($(($PasswordPolicy.minPwdAge / -864000000000 )) days) ,Minimum pwd length should be ($($PasswordPolicy.minPwdLength) characters),Passwordhistory Length ($($PasswordPolicy.pwdHistoryLength))``."

        
        # Set a successful result
        $result.success = $true
    }
 
 catch
    {
        # If this script fails we can assume the domain did not exist
        $result.output = "Domain $($name) does not exist ."
        
        # Set a failed result
        $result.success = $false
    }
    
    # Return the result and conver it to json
    return $result | ConvertTo-Json
}
    
   
  