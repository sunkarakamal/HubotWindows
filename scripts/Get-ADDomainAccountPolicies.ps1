

function Get-ADDomainAccountPolicies
{
   
    [CmdletBinding()]
    Param
    (
        # Name of the domain
        [Parameter(Mandatory=$true)]
        $Name
    )
     
    # Create a hashtable for the results
    $result = @{}
    
    # Use try/catch block            
    try
    {
        $RootDSE = Get-ADRootDSE -Server $name
        # Use ErrorAction Stop to make sure we can catch any errors
        $AccountLockoutPolicies = Get-ADObject $RootDSE.defaultNamingContext -Property lockoutDuration,lockoutObservationWindow,lockoutThreshold -Server $name
        
        # Create a string for sending back to slack. * and ` are used to make the output look nice in Slack. Details: http://bit.ly/MHSlackFormat
         $result.output = "Domain  is $($name) and policy type is Account Lockout, Lockoutduration is ($(($AccountLockoutPolicies.lockoutDuration / -600000000)) minutes) ,Threshold(number of times) (*$($AccountLockoutPolicies.lockoutThreshold)*)``."

        
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
    
   
   
   
   

  