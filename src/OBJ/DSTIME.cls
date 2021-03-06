/// Handle DSTIME using SQL 
/// select * from OBJ.DSTIME where DSTIME = lastversion
/// to show all
Class OBJ.DSTIME Extends %Persistent [ Final, SqlRowIdPrivate ]
{

Index idx On (ClassName, DSTIME, ObjectId) [ IdKey ];

Property DSTIME As %Integer [ ReadOnly, SqlColumnNumber = 2 ];

Property Version As %Integer [ Calculated, SqlColumnNumber = 7, SqlComputeCode = { set {*}={DSTIME}}, SqlComputed ];

Property ClassName As %String [ ReadOnly, SqlColumnNumber = 3 ];

Property ObjectId As %Binary [ ReadOnly, SqlColumnNumber = 4 ];

/// Returns the object's class name. The <var>fullname</var> determines how the
/// class name is represented. If it is 1 then it returns the full class name
/// including any package qualifier. If it is 0 (the default) then it returns the
/// name of the class without the package, this is mainly for backward compatibility
/// with the pre-package behaviour of %ClassName.
ClassMethod %ClassName(fullname As %Boolean) As %String [ ServerOnly = 0 ]
{
 Quit $select($get(fullname,0):$$$objClass,1:$$$ClassCompatibleName($$$objClass))
}

Property FilingOp As %Integer(DISPLAYLIST = ",Modified,New,Deleted", VALUELIST = ",0,1,2") [ ReadOnly, SqlColumnNumber = 5 ];

Property LastVersion As %Integer [ Calculated, SqlColumnNumber = 6, SqlComputeCode = { set {*}=+$Get(^OBJ.DSTIME)}, SqlComputed ];

/// to get actual last version and switch to new version
/// select top 1 lastVersion,OBJ.DSTIME_NewVersion() from OBJ.DSTIME
/// 
ClassMethod NewVersion() As %Integer [ SqlProc ]
{
 Quit $I(^OBJ.DSTIME)
}

/// to get rid of old versions 
/// select OBJ.DSTIME_DelVersion('ClassName',DSTIME) 
/// 
ClassMethod DelVersion(
	ClassName As %String = " ",
	DSTIME As %Integer = 0) As %Integer [ SqlProc ]
{
 Quit:'$l(ClassName) '$$$OK
 Kill ^OBJ.DSTIME(ClassName,+DSTIME)
 Quit $$$OK
}

Storage Default
{
<Data name="DSTIMEDefaultData">
<Attribute>FilingOp</Attribute>
<Structure>node</Structure>
</Data>
<DataLocation>^OBJ.DSTIME</DataLocation>
<DefaultData>DSTIMEDefaultData</DefaultData>
<IdLocation>^OBJ.DSTIMED</IdLocation>
<IndexLocation>^OBJ.DSTIMEI</IndexLocation>
<StreamLocation>^OBJ.DSTIMES</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
