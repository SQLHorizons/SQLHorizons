$path = "C:\Downloads"

ForEach ($Item in Get-ChildItem $path* -recurse)
{
    $acl = Get-ACL $Item.FullName
    $acl|Select-Object Path, Owner
}
