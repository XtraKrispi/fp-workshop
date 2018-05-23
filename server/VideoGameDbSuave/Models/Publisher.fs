namespace VideoGameDbSuave.Models
open System.Runtime.Serialization

[<DataContract>]
type Publisher = {
  [<field: DataMember(Name = "id")>]
  id : int
  [<field: DataMember(Name = "name")>]
  name : string
}